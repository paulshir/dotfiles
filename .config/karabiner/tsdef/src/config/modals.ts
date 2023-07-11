import {map, type NumberKeyValue} from 'karabiner.ts';
import {hyperModalLayer, type ModalLayerRuleBuilder} from '../helpers/modalLayer';
import {hyperVarName} from './common';

const numberToSpaces = Array.of<NumberKeyValue>(1, 2, 3, 4, 5, 6, 7, 8, 9).map(i => map(i).to(i, 'Hyper'));

/* eslint-disable-next-line */
const HOME = '${HOME}';
/* eslint-disable-next-line */
const glazedc = '${glazedc}'
function glazed(sub: string): string {
	return `glazedc=${HOME}/.local/bin/glazed; if [ -e ${glazedc} ]; then ${glazedc} ${sub}; else ${glazedc}.swift ${sub}; fi`;
}

function focus(dir: string): string {
	return glazed(`focus_window_${dir}`);
}

// Window Manipulation
const hyperW = hyperModalLayer('w', hyperVarName, 'hyper_w')
	.notifications(true)
	.manipulators([
		map('m').to$('open -g "rectangle-pro://execute-layout?name=layout1"'),
		map('h', 'shift').to$(glazed('resize_window_left_half')),
		map('j', 'shift').to$(glazed('resize_window_center')),
		map('k', 'shift').to$(glazed('resize_window_maximize')),
		map('l', 'shift').to$(glazed('resize_window_right_half')),
		map('h').to$(focus('left')),
		map('left_arrow').to$(focus('left')),
		map('l').to$(focus('right')),
		map('right_arrow').to$(focus('right')),
	])
	.fireOnceManipulators([
		...numberToSpaces,
		map(',').to$('open -g "rectangle-pro://execute-layout?name=layout1"'),
	]);

export const modalRules: ModalLayerRuleBuilder[] = [
	hyperW,
];
