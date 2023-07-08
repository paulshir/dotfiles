import {
	writeToProfile,
} from 'karabiner.ts';
import {fnRules} from './config/fn';
import {modifierRules} from './config/modifiers';

function profile(p: string): string {
	return process.argv.includes('--dry-run') ? '--dry-run' : p;
}

writeToProfile(profile('default'), [
	...modifierRules([]),
	...fnRules,
]);

