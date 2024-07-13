import {type RuleBuilder, map, rule, toRemoveNotificationMessage, toKey, mapSimultaneous} from 'karabiner.ts';

/* eslint-disable-next-line */
const cmdQSafety = rule('cmd + q safety').manipulators([
	map('q', 'left_command')
		.toNotificationMessage('cmdqsafety', '⌘+Q Safety is on')
		.toDelayedAction(
			toRemoveNotificationMessage('cmdqsafety'),
			toRemoveNotificationMessage('cmdqsafety'),
		)
		.toIfHeldDown(toKey('q', 'left_command')),
	map('q', 'right_command')
		.toNotificationMessage('cmdqsafety', '⌘+Q Safety is on')
		.toDelayedAction(
			toRemoveNotificationMessage('cmdqsafety'),
			toRemoveNotificationMessage('cmdqsafety'),
		)
		.toIfHeldDown(toKey('q', 'right_command')),
	map('f13', 'Hyper')
		.to$('open https://stackoverflow.com'),
]);

const combos = rule('cut, copy, paste combos').manipulators([
	mapSimultaneous(['z', 'x'])
		.to('x', 'left_command'),
	mapSimultaneous(['x', 'c'])
		.to('c', 'left_command'),
	mapSimultaneous(['c', 'v'])
		.to('v', 'left_command'),
]);

export const miscRules: RuleBuilder[] = [
	cmdQSafety,
	combos,
];
