﻿﻿﻿﻿﻿document.addEventListener('DOMContentLoaded', () => {
  const form = $('#loginForm');
  if (!form) return;

  const usernameInput = $('#username');
  const passwordInput = $('#password');
  const submitBtn = $('#submitBtn');

  const showError = (input, message) => {
    const formGroup = input.closest('.form-group');
    if (!formGroup) return;
    
    input.classList.remove('success');
    input.classList.add('error');
    
    let errorText = formGroup.querySelector('.form-text');
    if (!errorText) {
      errorText = document.createElement('div');
      errorText.className = 'form-text error';
      formGroup.appendChild(errorText);
    }
    errorText.className = 'form-text error';
    errorText.textContent = message;
  };

  const showSuccess = (input) => {
    const formGroup = input.closest('.form-group');
    if (!formGroup) return;
    
    input.classList.remove('error');
    input.classList.add('success');
    
    const errorText = formGroup.querySelector('.form-text');
    if (errorText) {
      errorText.remove();
    }
  };

  const clearError = (input) => {
    const formGroup = input.closest('.form-group');
    if (!formGroup) return;
    
    input.classList.remove('error', 'success');
    
    const errorText = formGroup.querySelector('.form-text');
    if (errorText) {
      errorText.remove();
    }
  };

  const validateUsername = () => {
    const value = usernameInput.value.trim();
    if (Validator.isEmpty(value)) {
      showError(usernameInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
      return false;
    }
    showSuccess(usernameInput);
    return true;
  };

  const validatePassword = () => {
    const value = passwordInput.value;
    if (Validator.isEmpty(value)) {
      showError(passwordInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
      return false;
    }
    showSuccess(passwordInput);
    return true;
  };

  usernameInput.addEventListener('blur', validateUsername);
  passwordInput.addEventListener('blur', validatePassword);

  usernameInput.addEventListener('input', () => {
    if (usernameInput.classList.contains('error')) {
      clearError(usernameInput);
    }
  });

  passwordInput.addEventListener('input', () => {
    if (passwordInput.classList.contains('error')) {
      clearError(passwordInput);
    }
  });

  form.addEventListener('submit', (e) => {
    const isUsernameValid = validateUsername();
    const isPasswordValid = validatePassword();
    
    if (!isUsernameValid || !isPasswordValid) {
      e.preventDefault();
      return;
    }
    
    if (submitBtn) {
      setButtonLoading(submitBtn, true, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ...');
    }
  });
});
