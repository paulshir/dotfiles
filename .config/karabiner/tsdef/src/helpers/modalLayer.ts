import {type BuildContext, type LayerKeyCode, type Rule, type RuleBuilder, ifVar, map, rule, toRemoveNotificationMessage, type Modifier, type FromKeyCode} from 'karabiner.ts';
import {type BasicManipulatorBuilder, type BasicRuleBuilder} from './types';

const blockKeys: FromKeyCode[] = [
	...[...`${'`'}1234567890-=qwertyuiop[]\\asdfghjkl;'zxcvbnm,./`].map(v => v as FromKeyCode),
	'return_or_enter',
	'delete_or_backspace',
];

export type ModalLayerRuleBuilder = {
	readonly varName: string;
	notifications(show: boolean): ModalLayerRuleBuilder;
	manipulators(src: BasicManipulatorBuilder[]): ModalLayerRuleBuilder;
	fireOnceManipulators(src: BasicManipulatorBuilder[]): ModalLayerRuleBuilder;
} & RuleBuilder;

export type ModalLayerTrigger = {
	key_code: LayerKeyCode;
	modifiers?: {
		mandatory?: Modifier[] | ['any'];
		optional?: Modifier[] | ['any'];
	};
	varNameActive?: string;
};

function isLayerKeyCode(obj: LayerKeyCode | ModalLayerTrigger): obj is LayerKeyCode {
	if ((obj as any).key_code === undefined) {
		return true;
	}

	return false;
}

const hyperModifiers: Modifier[] = ['command', 'option', 'control', 'shift'];

class BasicModalLayerRuleBuilder implements ModalLayerRuleBuilder {
	private readonly baseBuilder: BasicRuleBuilder;
	private readonly manipulatorSources: BasicManipulatorBuilder[] = [];
	private readonly fireOnceManipulatorSources: BasicManipulatorBuilder[] = [];

	private showNotifications = false;
	private buildCheck = false;

	constructor(private readonly layerKeys: ModalLayerTrigger[], readonly varName: string) {
		this.varName = varName;
		this.baseBuilder = rule(`Layer - ${varName}`);
	}

	notifications(show: boolean): ModalLayerRuleBuilder {
		this.showNotifications = show;
		return this;
	}

	manipulators(src: BasicManipulatorBuilder[]): ModalLayerRuleBuilder {
		src.forEach(v => this.manipulatorSources.push(v));
		return this;
	}

	fireOnceManipulators(src: BasicManipulatorBuilder[]): ModalLayerRuleBuilder {
		src.forEach(v => this.fireOnceManipulatorSources.push(v));
		return this;
	}

	build(context?: BuildContext): Rule {
		if (this.buildCheck) {
			throw new Error('Manipulators have already been built');
		}

		this.buildCheck = true;

		this.baseBuilder.manipulators([
			...this.layerKeys.map(k => this.buildTriggerBase(k)).map(k => this.applyEnableLayer(k)),
			...this.layerKeys.map(k => this.buildTriggerBase(k)).map(k => this.applyDisableLayer(k)),
			this.applyDisableLayer(map('escape')),
			this.applyDisableLayer(map('return_or_enter')),
			...this.manipulatorSources.map(m => this.applyManipulatorCondition(m)),
			...this.fireOnceManipulatorSources.map(m => this.applyFireOnceManipulatorCondition(m)),
			// This.applyManipulatorCondition(map({any: 'key_code'}).toNone()),
		]);

		return this.baseBuilder.build(context);
	}

	private buildTriggerBase(t: ModalLayerTrigger): BasicManipulatorBuilder {
		const {varNameActive} = t;
		delete (t.varNameActive);
		const r = map(t);

		if (varNameActive) {
			r.condition(ifVar(varNameActive, 1));
		}

		return r;
	}

	private applyEnableLayer(m: BasicManipulatorBuilder): BasicManipulatorBuilder {
		m.toVar(this.varName, 1);
		m.condition(ifVar(this.varName, 1).unless());

		if (this.showNotifications) {
			const msgId = `${this.varName}_activated`;
			m.toNotificationMessage(msgId, `${this.varName} Layer activated`);
			m.toDelayedAction(
				toRemoveNotificationMessage(msgId),
				toRemoveNotificationMessage(msgId),
			);
		}

		return m;
	}

	private applyDisableLayer(m: BasicManipulatorBuilder): BasicManipulatorBuilder {
		m.toVar(this.varName, 0);
		m.condition(ifVar(this.varName, 1));

		if (this.showNotifications) {
			const msgId = `${this.varName}_deactivated`;
			m.toNotificationMessage(msgId, `${this.varName} Layer deactivated`);
			m.toDelayedAction(
				toRemoveNotificationMessage(msgId),
				toRemoveNotificationMessage(msgId),
			);
		}

		return m;
	}

	private applyManipulatorCondition(m: BasicManipulatorBuilder): BasicManipulatorBuilder {
		m.condition(ifVar(this.varName, 1));

		return m;
	}

	private applyFireOnceManipulatorCondition(m: BasicManipulatorBuilder): BasicManipulatorBuilder {
		return this.applyDisableLayer(m);
	}
}

/* eslint-disable @typescript-eslint/naming-convention */
export function modalLayer(layerKey: LayerKeyCode | ModalLayerTrigger, varName: string): ModalLayerRuleBuilder {
	const lk = isLayerKeyCode(layerKey) ? {key_code: layerKey} : layerKey;
	return new BasicModalLayerRuleBuilder([lk], varName);
}

export function hyperModalLayer(layerKey: LayerKeyCode, hyperActiveVarName: string, varName: string): ModalLayerRuleBuilder {
	return new BasicModalLayerRuleBuilder([
		{key_code: layerKey, modifiers: {mandatory: hyperModifiers}},
		{key_code: layerKey, varNameActive: hyperActiveVarName},
	], varName);
}
/* eslint-enable @typescript-eslint/naming-convention */
