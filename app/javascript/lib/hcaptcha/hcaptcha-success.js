window.hcaptchaSuccess = (response) => {
  const event = new CustomEvent('hcaptcha-response', {response});
  document.dispatchEvent(event);
};
