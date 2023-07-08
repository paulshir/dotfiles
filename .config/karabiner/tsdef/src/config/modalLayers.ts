import {map, type NumberKeyValue} from 'karabiner.ts';
import {hyperModalLayer} from '../helpers/modalLayer';
import {hyperVarName} from './common';

const numberToSpaces = Array.of<NumberKeyValue>(1, 2, 3, 4, 5, 6, 7, 8, 9).map(i => map(i).to(i, 'Hyper'));

// Example
const hyperP = hyperModalLayer('p', hyperVarName, 'hyper_p')
	.notifications(true)
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

export const modalLayers = [
	hyperP,
];
