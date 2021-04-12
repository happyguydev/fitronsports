declare interface ErrorResponse {
  backtrace?: string;
  code: string;
  detail?: Record<string, any>;
  extensions?: {
    code: string;
    status: number;
  };
  message: string;
  status: number;
}

declare type JSONResponse<T> = {
  data?: T;
  error?: ErrorResponse;
};

declare type AjaxResponse<T = any> = CustomEvent<
  [JSONResponse<T>, string | null, XMLHttpRequest]
>;

declare module '*.js.erb' {
  const module: any;
  export default module;
}
