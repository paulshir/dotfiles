import {
	writeToProfile,
} from 'karabiner.ts';
import {fnRules} from './config/fn';
import {modifierRules} from './config/modifiers';
import {modalRules} from './config/modals';
import {miscRules} from './config/misc';

function profile(p: string): string {
	return process.argv.includes('--dry-run') ? '--dry-run' : p;
}

writeToProfile(profile('default'), [
	...modifierRules([...modalRules.map(b => b.varName)]),
	...modalRules,
	...fnRules,
	...miscRules,
]);

