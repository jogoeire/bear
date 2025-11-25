export const theme = {
  colors: {
    // Base color
    color: '#ffffff',
    
    // Brand colors
    bearGreen: '#07a25f',
    bearRed: '#ff6b6b',
    bearYellow: '#ffd700',
    bearPurple: '#6b47ff',
    bearLightBlue: '#b3e0ff',
    
    // Gray scale
    bearGray90: '#161616',
    bearGray80: '#2d2d2d',
    bearGray70: '#434343',
    bearGray60: '#5a5a5a',
    bearGray50: '#707070',
    bearGray40: '#868686',
    bearGray30: '#9d9d9d',
    bearGray20: '#b3b3b3',
    bearGray10: '#cacaca',
    bearGray5: '#e0e0e0',
    bearGray3: '#e6e6e6',
    bearGray1: '#f3f3f3',
    bearBlue: '#2B67F6'
    bearLightTan: '#FAF6F4'
  },
} as const;

// Type export for TypeScript
export type Theme = typeof theme;

