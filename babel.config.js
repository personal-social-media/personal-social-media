module.exports = function(api) {
  const validEnv = ['development', 'test', 'production'];
  const currentEnv = api.env();
  const isDevelopmentEnv = api.env('development');
  const isProductionEnv = api.env('production');
  const isTestEnv = api.env('test');

  if (!validEnv.includes(currentEnv)) {
    throw new Error(
        'Please specify a valid `NODE_ENV` or ' +
        '`BABEL_ENV` environment variables. Valid values are "development", ' +
        '"test", and "production". Instead, received: ' +
        JSON.stringify(currentEnv) +
        '.',
    );
  }

  return {
    plugins: [
      'babel-plugin-macros',
      '@babel/plugin-syntax-dynamic-import',
      isTestEnv && 'babel-plugin-dynamic-import-node',
      '@babel/plugin-transform-destructuring',
      '@babel/plugin-proposal-class-properties',
      [
        '@babel/plugin-proposal-object-rest-spread',
        {
          useBuiltIns: true,
        },
      ],
      [
        '@babel/plugin-transform-runtime',
        {
          corejs: false,
          helpers: false,
          regenerator: true,
        },
      ],
      [
        '@babel/plugin-transform-regenerator',
        {
          async: false,
        },
      ],
      isProductionEnv && [
        'babel-plugin-transform-react-remove-prop-types',
        {
          removeImport: true,
        },
      ],
    ].filter(Boolean),
    presets: [
      isTestEnv && [
        '@babel/preset-env',
        {
          modules: 'commonjs',
          targets: {
            node: 'current',
          },
        },
        [
          '@babel/preset-react',
          {
            development: true,
            runtime: 'automatic',
            useBuiltIns: true,
          },
        ],
      ],
      (isProductionEnv || isDevelopmentEnv) && [
        '@babel/preset-env',
        {
          corejs: 3,
          exclude: ['transform-typeof-symbol'],
          forceAllTransforms: true,
          loose: false,
          modules: false,
          useBuiltIns: 'entry',
        },
      ],
      [
        '@babel/preset-react',
        {
          development: isDevelopmentEnv || isTestEnv,
          runtime: 'automatic',
          useBuiltIns: true,
        },
      ],
    ].filter(Boolean),
  };
};
