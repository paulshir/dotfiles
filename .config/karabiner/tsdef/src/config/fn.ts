import {
	map,
	rule,
	withMapper,
	type FromKeyCode,
	type ToKeyCode,
} from 'karabiner.ts';
import {fnAppKeys, fnKeys} from './common';

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

const fnZ = rule('fn+z to sleep')
	.manipulators([
		map('z', 'fn')
			.to('power', ['left_control', 'left_shift']),
	]);

export const fnRules = [
	// fnConsumer,
	fnAndNumbers,
	fnArrows,
	fnMedia,
	fnZ,
];
