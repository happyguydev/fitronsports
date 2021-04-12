import { get, result } from 'lodash';

interface IParsedError {
  isValidation: boolean;
  validationErrors?: string[];
  message: string;
  code: string;
}

export function parseApplicationError(data: any): IParsedError {
  const error = get(data, 'error', data);
  const code = get(error, 'code');
  const message = typeof error === 'string' ? error : get(error, 'message');

  if (/Validation/i.test(code)) {
    return {
      isValidation: true,
      validationErrors: get(error, 'extensions.messages', []),
      message,
      code,
    };
  }

  return {
    message,
    code,
    isValidation: false,
  };
}

export function parseError(resultError: any): IParsedError {
  console.log(resultError);

  if (get(resultError, 'response.data')) {
    return parseApplicationError(get(resultError, 'response.data'));
  }

  return {
    code: resultError.code ?? 'UNKNOWN',
    message: resultError.message,
    isValidation: false,
  };
}
