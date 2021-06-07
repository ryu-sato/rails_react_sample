module.exports = {
  parser: '@typescript-eslint/parser',
  extends: ['weseek', 'weseek/react', 'weseek/typescript'],
  env: {
    jquery: true,
  },
  globals: {
    $: true,
    jquery: true,
    emojione: true,
    hljs: true,
    ScrollPosStyler: true,
    window: true,
  },
  rules: {
    'import/prefer-default-export': 'off',
    '@typescript-eslint/no-explicit-any': 'off',
    'no-use-before-define': 'off',
    indent: [
      'error',
      2,
      {
        SwitchCase: 1,
        ignoredNodes: [
          'JSXElement *',
          'JSXElement',
          'JSXAttribute',
          'JSXSpreadAttribute',
        ],
        ArrayExpression: 'first',
        FunctionDeclaration: { body: 1, parameters: 2 },
        FunctionExpression: { body: 1, parameters: 2 },
      },
    ],
  },
};
