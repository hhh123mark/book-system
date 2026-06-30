﻿﻿﻿﻿﻿document.addEventListener('DOMContentLoaded', () => {
  const form = $('#registerForm');
  if (!form) return;

  const usernameInput = $('#username');
  const emailInput = $('#email');
  const phoneInput = $('#phone');
  const passwordInput = $('#password');
  const confirmPasswordInput = $('#confirmPassword');
  const submitBtn = $('#submitBtn');
  const passwordStrength = $('#passwordStrength');

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

  const showSuccess = (input, message = '') => {
    const formGroup = input.closest('.form-group');
    if (!formGroup) return;
    
    input.classList.remove('error');
    input.classList.add('success');
    
    let msgText = formGroup.querySelector('.form-text');
    if (message) {
      if (!msgText) {
        msgText = document.createElement('div');
        msgText.className = 'form-text success';
        formGroup.appendChild(msgText);
      }
      msgText.className = 'form-text success';
      msgText.textContent = message;
    } else if (msgText) {
      msgText.remove();
    }
  };

  const clearStatus = (input) => {
    const formGroup = input.closest('.form-group');
    if (!formGroup) return;
    
    input.classList.remove('error', 'success');
    
    const msgText = formGroup.querySelector('.form-text');
    if (msgText) {
      msgText.remove();
    }
  };

  const validateUsername = debounce(async () => {
    const value = usernameInput.value.trim();
    
    if (Validator.isEmpty(value)) {
      showError(usernameInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
      return false;
    }
    
    if (!Validator.minLength(value, 3)) {
      showError(usernameInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value 3 '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
      return false;
    }
    
    if (!Validator.maxLength(value, 20)) {
      showError(usernameInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value 20 '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
      return false;
    }
    
    if (!/^[a-zA-Z0-9_]+$/.test(value)) {
      showError(usernameInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value 、 '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
      return false;
    }
    
    try {
      const response = await ajax(`/checkUsername?username=${encodeURIComponent(value)}`);
      if (response.valid) {
        showSuccess(usernameInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
        return true;
      } else {
        showError(usernameInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
        return false;
      }
    } catch (e) {
      showError(usernameInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ， '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
      return false;
    }
  }, 500);

  const validateEmail = () => {
    const value = emailInput.value.trim();
    
    if (Validator.isEmpty(value)) {
      showError(emailInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
      return false;
    }
    
    if (!Validator.isEmail(value)) {
      showError(emailInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
      return false;
    }
    
    showSuccess(emailInput);
    return true;
  };

  const validatePhone = () => {
    const value = phoneInput.value.trim();
    
    if (Validator.isEmpty(value)) {
      showError(phoneInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
      return false;
    }
    
    if (!Validator.isPhone(value)) {
      showError(phoneInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
      return false;
    }
    
    showSuccess(phoneInput);
    return true;
  };

  const updatePasswordStrength = () => {
    const value = passwordInput.value;
    
    if (!passwordStrength) return;
    
    const fill = passwordStrength.querySelector('.password-strength-fill');
    const text = passwordStrength.querySelector('.password-strength-text');
    
    if (!fill || !text) return;
    
    fill.className = 'password-strength-fill';
    
    if (Validator.isEmpty(value)) {
      text.textContent = '';
      return;
    }
    
    const strength = Validator.getPasswordStrength(value);
    fill.classList.add(strength.level);
    text.textContent = ` '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ：${strength.text}`;
    
    if (strength.level === 'weak') {
      text.className = 'password-strength-text text-danger';
    } else if (strength.level === 'medium') {
      text.className = 'password-strength-text text-warning';
    } else {
      text.className = 'password-strength-text text-success';
    }
  };

  const validatePassword = () => {
    const value = passwordInput.value;
    
    if (Validator.isEmpty(value)) {
      showError(passwordInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
      return false;
    }
    
    if (!Validator.minLength(value, 6)) {
      showError(passwordInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value 6 '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
      return false;
    }
    
    showSuccess(passwordInput);
    return true;
  };

  const validateConfirmPassword = () => {
    const value = confirmPasswordInput.value;
    const password = passwordInput.value;
    
    if (Validator.isEmpty(value)) {
      showError(confirmPasswordInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
      return false;
    }
    
    if (!Validator.equals(value, password)) {
      showError(confirmPasswordInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
      return false;
    }
    
    showSuccess(confirmPasswordInput);
    return true;
  };

  usernameInput.addEventListener('blur', validateUsername);
  usernameInput.addEventListener('input', () => {
    if (usernameInput.classList.contains('error') || usernameInput.classList.contains('success')) {
      clearStatus(usernameInput);
    }
  });

  emailInput.addEventListener('blur', validateEmail);
  emailInput.addEventListener('input', () => {
    if (emailInput.classList.contains('error')) {
      clearStatus(emailInput);
    }
  });

  phoneInput.addEventListener('blur', validatePhone);
  phoneInput.addEventListener('input', () => {
    if (phoneInput.classList.contains('error')) {
      clearStatus(phoneInput);
    }
  });

  passwordInput.addEventListener('input', () => {
    updatePasswordStrength();
    if (passwordInput.classList.contains('error')) {
      clearStatus(passwordInput);
    }
    if (confirmPasswordInput.value) {
      validateConfirmPassword();
    }
  });
  passwordInput.addEventListener('blur', validatePassword);

  confirmPasswordInput.addEventListener('blur', validateConfirmPassword);
  confirmPasswordInput.addEventListener('input', () => {
    if (confirmPasswordInput.classList.contains('error')) {
      clearStatus(confirmPasswordInput);
    }
  });

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const results = await Promise.all([
      validateUsername(),
      validateEmail(),
      validatePhone(),
      validatePassword(),
      validateConfirmPassword()
    ]);
    
    if (results.some(r => !r)) {
      return;
    }
    
    if (submitBtn) {
      setButtonLoading(submitBtn, true, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ...');
    }
    
    form.submit();
  });
});
