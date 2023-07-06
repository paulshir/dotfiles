import {type layer, type rule, type map, type ifVar, type withMapper, type toConsumerKey} from 'karabiner.ts';

type FirstParameter<T extends (...args: any[]) => any> = T extends (...args: [infer P, ...any[]]) => any ? P : never;
type SecondParameter<T extends (...args: any[]) => any> = T extends (...args: [any, infer P, ...any[]]) => any ? P : never;
type ThirdParameter<T extends (...args: any[]) => any> = T extends (...args: [any, any, infer P, ...any[]]) => any ? P : never;

export type LayerRuleBuilder = ReturnType<typeof layer>;
export type ManipulatorBuilder = ReturnType<typeof withMapper>;
export type BasicManipulatorBuilder = ReturnType<typeof map>;
export type BasicRuleBuilder = ReturnType<typeof rule>;
export type ConditionBuilder = ReturnType<typeof ifVar>;

export type ToConsumerKeyCode = FirstParameter<typeof toConsumerKey>;

