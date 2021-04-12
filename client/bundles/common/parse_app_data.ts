interface AppData {
  props: Record<string, any>;
}

const parseAppData = (): AppData => {
  const script = document.getElementById('__APP_DATA');
  if (!script) {
    return {
      props: {},
    };
  }

  try {
    const data = JSON.parse(script.textContent ?? '{props: {}}');
    return data;
  } catch (error) {
    console.warn(`[parseWindowData]: Failed to parse`, error);
    return {
      props: {},
    };
  }
};

export { parseAppData };
