import {
	map,
	rule,
	withMapper,
	writeToProfile,
	type FromKeyCode,
	type ToKeyCode,
} from 'karabiner.ts';
import {fnAppKeys, fnKeys, ifAppleKeyboard, ifAppleVendor, ifNonUsAppleKeyboard, ifUsAppleKeyboard} from './common';

function profile(p: string): string {
	return process.argv.includes('--dry-run') ? '--dry-run' : p;
}

const capsLock = rule('caps_lock on apple keyboards to left_control/escape')
	.manipulators([
		map('caps_lock', [], 'any')
			.condition(ifAppleKeyboard)
			.to('left_control')
			.toIfAlone('escape'),
	]);

const fnConsumer = rule('f1-f12 to consumer keys if held')
	.manipulators([
		...fnKeys.map((key, i) => map(key).toIfAlone(key).toIfHeldDown(fnAppKeys[i])),
	]);

const fnAndNumbers = rule('fn+numbers to f1-f12')
	.manipulators([
		withMapper([1, 2, 3, 4, 5, 6, 7, 8, 9, 0, '-', '='])((key, i) =>
			map(key, 'fn', 'any').to(fnKeys[i]),
		),
	])
	.build();

const fnArrows = rule('fn+h/j/k/l to arrows')
	.manipulators([
		...Array.of<[FromKeyCode, ToKeyCode]>(
			['h', 'left_arrow'],
			['j', 'down_arrow'],
			['k', 'up_arrow'],
			['l', 'right_arrow'],
		).map(k => map(k[0], 'fn', 'any').to(k[1])),
	]);

const fnMedia = rule('fn+q/w/e/a/s/d/f to media keys')
	.manipulators([
		...Array.of<[FromKeyCode, ToKeyCode]>(
			['q', 'rewind'],
			['w', 'play_or_pause'],
			['e', 'fastforward'],
			['a', 'mute'],
			['s', 'volume_decrement'],
			['d', 'volume_increment'],
			['f', 'mute'],
		).map(k => map(k[0], 'fn', 'any').to(k[1])),
	]);

const hyperEscape = rule('escape to hyper/escape')
	.manipulators([
		map('escape', '', 'any')
			.to('left_control', ['left_shift', 'left_command', 'left_option'])
			.toIfAlone('escape'),
	]);

const leftControlApple = rule('left_control on apple keyboards to hyper')
	.manipulators([
		map('left_control', '', 'any')
			.condition(ifAppleVendor)
			.to('left_control', ['left_shift', 'left_command', 'left_option']),
	]);

const graveAccentTildeUs = rule('grave_accent_and_tilde on US apple keyboards to hyper/grave_accent_and_tilde')
	.manipulators([
		map('grave_accent_and_tilde', '', 'any')
			.condition(ifUsAppleKeyboard)
			.to('left_control', ['left_shift', 'left_command', 'left_option'])
			.toIfAlone('grave_accent_and_tilde'),
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

const fnZ = rule('fn+z to sleep')
	.manipulators([
		map('z', 'fn')
			.to('power', ['left_control', 'left_shift']),
	]);

writeToProfile(profile('default'), [
	capsLock,
	fnConsumer,
	fnAndNumbers,
	fnArrows,
	fnMedia,
	hyperEscape,
	leftControlApple,
	graveAccentTildeUs,
	graveAccentTildeNonUs,
	fnZ,
]);

