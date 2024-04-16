import {type RuleBuilder, map, rule, toRemoveNotificationMessage, toKey} from 'karabiner.ts';

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

export const miscRules: RuleBuilder[] = [
	cmdQSafety,
];
