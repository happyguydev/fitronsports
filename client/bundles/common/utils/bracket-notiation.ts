/* eslint-disable @typescript-eslint/no-explicit-any */
/**
 * Converts a JS object to bracket notation
 *
 * @param {Record<string, any>} item - The object to be converted to bracket notation
 * @returns {Record<string, any>}
 *
 */
const convertToBracketNotation = (item: Record<string, any>) => {
  const result: Record<string, any> = {};
  const recurse = (object: Record<string, any>, current?: string) => {
    Object.keys(object).forEach((key) => {
      const value = object[key];
      const newKey = current ? `${current}[${key}]` : key;
      if (value && typeof value === 'object') {
        recurse(value, newKey);
      } else {
        result[newKey] = value;
      }
    });
  };
  recurse(item);
  return result;
};

export { convertToBracketNotation };
