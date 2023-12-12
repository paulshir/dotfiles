import {type RuleBuilder, map, rule, toSetVar} from 'karabiner.ts';
import {activateHyper, deactivateHyper, ifBuiltInKeyboard, ifNonUsAppleKeyboard, ifUsAppleKeyboard} from './common';

export const hyperVarName = 'hyper_active';

function capsLock(clearVarsOnEscape: string[]): RuleBuilder {
	const r = map('caps_lock', [], 'any')
		.condition(ifBuiltInKeyboard)
		.to('left_control')
		.toIfAlone('escape');

	clearVarsOnEscape.forEach(v => r.toIfAlone(toSetVar(v, 0)));

	return rule('caps_lock on apple keyboards to left_control/escape').manipulators([r]);
}

function hyperEscape(clearVarsOnEscape: string[]): RuleBuilder {
	const r = map('escape', '', 'any')
		.condition(ifBuiltInKeyboard)
		.to(activateHyper)
		.to('left_control', ['left_shift', 'left_command', 'left_option'])
		.toIfAlone('escape')
		.toAfterKeyUp(deactivateHyper);

	clearVarsOnEscape.forEach(v => r.toIfAlone(toSetVar(v, 0)));

	return rule('escape to hyper/escape').manipulators([r]);
}

const leftControlApple = rule('left_control on apple keyboards to hyper')
	.manipulators([
		map('left_control', '', 'any')
			.condition(ifBuiltInKeyboard)
			.to(activateHyper)
			.to('left_control', ['left_shift', 'left_command', 'left_option'])
			.toAfterKeyUp(deactivateHyper),
	]);

const graveAccentTildeUs = rule('grave_accent_and_tilde on US apple keyboards to hyper/grave_accent_and_tilde')
	.manipulators([
		map('grave_accent_and_tilde', '', 'any')
			.condition(ifUsAppleKeyboard)
			.to(activateHyper)
			.to('left_control', ['left_shift', 'left_command', 'left_option'])
			.toIfAlone('grave_accent_and_tilde')
			.toAfterKeyUp(deactivateHyper),
	]);

const graveAccentTildeNonUs = rule('non_us_backslash on non US apple keyboards to hyper/grave_accent_and_tilde')
	.manipulators([
		map('non_us_backslash', '', 'any')
			.condition(ifNonUsAppleKeyboard)
			.to('left_control', ['left_shift', 'left_command', 'left_option'])
			.toIfAlone('grave_accent_and_tilde'),
		map('grave_accent_and_tilde', '', 'any')
			.condition(ifNonUsAppleKeyboard)
			.to('non_us_backslash'),
	]);

export function modifierRules(clearVarsOnEscape: string[]): RuleBuilder[] {
	return [
		capsLock(clearVarsOnEscape),
		hyperEscape(clearVarsOnEscape),
		leftControlApple,
		graveAccentTildeUs,
		graveAccentTildeNonUs,
	];
}
