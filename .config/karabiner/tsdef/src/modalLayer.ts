import {type BuildContext, type LayerKeyCode, type Rule, type RuleBuilder, ifVar, map, rule, toRemoveNotificationMessage, type NumberKeyValue} from '../node_modules/karabiner.ts/';
import {type BasicManipulatorBuilder, type BasicRuleBuilder} from './types';

export class ModalLayerRuleBuilder implements RuleBuilder {
	private readonly baseBuilder: BasicRuleBuilder;
	private readonly manipulatorSources: BasicManipulatorBuilder[] = [];
	private readonly fireOnceManipulatorSources: BasicManipulatorBuilder[] = [];

	private debugFlag = false;
	private buildCheck = false;

	constructor(private readonly layerKey: LayerKeyCode, private readonly varName: string) {
		this.layerKey = layerKey;
		this.varName = varName;
		this.baseBuilder = rule(`Layer - ${varName}`);
	}

	debug(debug: boolean): this {
		this.debugFlag = debug;
		return this;
	}

	manipulators(src: BasicManipulatorBuilder[]): this {
		src.forEach(v => this.manipulatorSources.push(v));
		return this;
	}

	fireOnceManipulators(src: BasicManipulatorBuilder[]): this {
		src.forEach(v => this.fireOnceManipulatorSources.push(v));
		return this;
	}

	build(context?: BuildContext): Rule {
		if (this.buildCheck) {
			throw new Error('Manipulators have already been built');
		}

		this.buildCheck = true;

		this.baseBuilder.manipulators([
			this.applyEnableLayer(map(this.layerKey, 'Hyper')),
			this.applyEnableLayer(map(this.layerKey).condition(ifVar('hyper_active', 1))),
			this.applyDisableLayer(map(this.layerKey, 'Hyper')),
			this.applyDisableLayer(map(this.layerKey).condition(ifVar('hyper_active', 1))),
			this.applyDisableLayer(map('escape')),
			...this.manipulatorSources.map(m => this.applyManipulatorCondition(m)),
			...this.fireOnceManipulatorSources.map(m => this.applyFireOnceManipulatorCondition(m)),
			this.applyManipulatorCondition(map({any: 'key_code', modifiers: {optional: ['any']}}).toNone()),
		]);

		return this.baseBuilder.build(context);
	}

	private applyEnableLayer(m: BasicManipulatorBuilder): BasicManipulatorBuilder {
		m.toVar(this.varName, 1);
		m.condition(ifVar(this.varName, 1).unless());

		if (this.debugFlag) {
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

		if (this.debugFlag) {
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

export function modalLayer(layerKey: LayerKeyCode, varName: string): ModalLayerRuleBuilder {
	return new ModalLayerRuleBuilder(layerKey, varName);
}

const numberToSpaces = Array.of<NumberKeyValue>(1, 2, 3, 4, 5, 6, 7, 8, 9).map(i => map(i).to(i, 'Hyper'));

// Example
export const hyperP = modalLayer('p', 'hyper_p')
	.debug(true)
	.manipulators([
		...numberToSpaces,
		map('m').to$('open -g "rectangle-pro://execute-layout?name=layout1"'),
		map('h').to$('open -g "rectangle-pro://execute-action?name=left-half"'),
		map('j').to$('open -g "rectangle-pro://execute-action?name=center"'),
		map('k').to$('open -g "rectangle-pro://execute-action?name=maximize"'),
		map('l').to$('open -g "rectangle-pro://execute-action?name=right-half"'),
	])
	.fireOnceManipulators([
		map(',').to$('open -g "rectangle-pro://execute-layout?name=layout1"'),
	]);
