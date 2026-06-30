﻿﻿﻿﻿﻿document.addEventListener('DOMContentLoaded', () => {
  const avatarUpload = $('#avatarUpload');
  const avatarPreview = $('#avatarPreview');
  const avatarInput = $('#avatarInput');
  const profileForm = $('#profileForm');
  const passwordForm = $('#passwordForm');
  const saveProfileBtn = $('#saveProfileBtn');
  const changePasswordBtn = $('#changePasswordBtn');

  if (avatarUpload && avatarInput && avatarPreview) {
    avatarUpload.addEventListener('click', () => {
      avatarInput.click();
    });

    avatarInput.addEventListener('change', async (e) => {
      const file = e.target.files[0];
      if (!file) return;

      if (!file.type.startsWith('image/')) {
        showToast(' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'error');
        return;
      }

      if (file.size > 5 * 1024 * 1024) {
        showToast(' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value 5MB', 'error');
        return;
      }

      const reader = new FileReader();
      reader.onload = (event) => {
        avatarPreview.src = event.target.result;
      };
      reader.readAsDataURL(file);

      showLoading();

      try {
        const response = await uploadFile(file, 'avatar');
        
        if (response.success) {
          showToast(' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'success');
          const avatarPathInput = $('#avatarPath');
          if (avatarPathInput) {
            avatarPathInput.value = response.path;
          }
        } else {
          showToast(response.message || ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'error');
        }
      } catch (e) {
        showToast(e.message || ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'error');
      } finally {
        hideLoading();
      }
    });
  }

  if (profileForm) {
    const nicknameInput = $('#nickname');
    const emailInput = $('#email');
    const phoneInput = $('#phone');

    const showError = (input, message) => {
      const formGroup = input.closest('.form-group');
      if (!formGroup) return;
      
      input.classList.add('error');
      input.classList.remove('success');
      
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
      if (!value) {
        showSuccess(phoneInput);
        return true;
      }
      if (!Validator.isPhone(value)) {
        showError(phoneInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
        return false;
      }
      showSuccess(phoneInput);
      return true;
    };

    const validateNickname = () => {
      const value = nicknameInput.value.trim();
      if (Validator.isEmpty(value)) {
        showError(nicknameInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
        return false;
      }
      if (!Validator.maxLength(value, 50)) {
        showError(nicknameInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value 50 '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
        return false;
      }
      showSuccess(nicknameInput);
      return true;
    };

    if (emailInput) {
      emailInput.addEventListener('blur', validateEmail);
      emailInput.addEventListener('input', () => {
        if (emailInput.classList.contains('error')) {
          emailInput.classList.remove('error');
          const formGroup = emailInput.closest('.form-group');
          const errorText = formGroup?.querySelector('.form-text');
          if (errorText) errorText.remove();
        }
      });
    }

    if (phoneInput) {
      phoneInput.addEventListener('blur', validatePhone);
      phoneInput.addEventListener('input', () => {
        if (phoneInput.classList.contains('error')) {
          phoneInput.classList.remove('error');
          const formGroup = phoneInput.closest('.form-group');
          const errorText = formGroup?.querySelector('.form-text');
          if (errorText) errorText.remove();
        }
      });
    }

    if (nicknameInput) {
      nicknameInput.addEventListener('blur', validateNickname);
      nicknameInput.addEventListener('input', () => {
        if (nicknameInput.classList.contains('error')) {
          nicknameInput.classList.remove('error');
          const formGroup = nicknameInput.closest('.form-group');
          const errorText = formGroup?.querySelector('.form-text');
          if (errorText) errorText.remove();
        }
      });
    }

    profileForm.addEventListener('submit', (e) => {
      let isValid = true;
      
      if (nicknameInput && !validateNickname()) isValid = false;
      if (emailInput && !validateEmail()) isValid = false;
      if (phoneInput && !validatePhone()) isValid = false;

      if (!isValid) {
        e.preventDefault();
        return;
      }

      if (saveProfileBtn) {
        setButtonLoading(saveProfileBtn, true, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ...');
      }
    });
  }

  if (passwordForm) {
    const oldPasswordInput = $('#oldPassword');
    const newPasswordInput = $('#newPassword');
    const confirmPasswordInput = $('#confirmNewPassword');
    const passwordStrength = $('#passwordStrength');

    const showError = (input, message) => {
      const formGroup = input.closest('.form-group');
      if (!formGroup) return;
      
      input.classList.add('error');
      input.classList.remove('success');
      
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

    const clearStatus = (input) => {
      const formGroup = input.closest('.form-group');
      if (!formGroup) return;
      
      input.classList.remove('error', 'success');
      
      const errorText = formGroup.querySelector('.form-text');
      if (errorText) {
        errorText.remove();
      }
    };

    const validateOldPassword = () => {
      const value = oldPasswordInput.value;
      if (Validator.isEmpty(value)) {
        showError(oldPasswordInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
        return false;
      }
      showSuccess(oldPasswordInput);
      return true;
    };

    const updatePasswordStrength = () => {
      const value = newPasswordInput.value;
      
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

    const validateNewPassword = () => {
      const value = newPasswordInput.value;
      
      if (Validator.isEmpty(value)) {
        showError(newPasswordInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
        return false;
      }
      
      if (!Validator.minLength(value, 6)) {
        showError(newPasswordInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value 6 '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
        return false;
      }
      
      showSuccess(newPasswordInput);
      return true;
    };

    const validateConfirmPassword = () => {
      const value = confirmPasswordInput.value;
      const newPassword = newPasswordInput.value;
      
      if (Validator.isEmpty(value)) {
        showError(confirmPasswordInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
        return false;
      }
      
      if (!Validator.equals(value, newPassword)) {
        showError(confirmPasswordInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
        return false;
      }
      
      showSuccess(confirmPasswordInput);
      return true;
    };

    if (oldPasswordInput) {
      oldPasswordInput.addEventListener('blur', validateOldPassword);
      oldPasswordInput.addEventListener('input', () => {
        if (oldPasswordInput.classList.contains('error')) {
          clearStatus(oldPasswordInput);
        }
      });
    }

    if (newPasswordInput) {
      newPasswordInput.addEventListener('input', () => {
        updatePasswordStrength();
        if (newPasswordInput.classList.contains('error')) {
          clearStatus(newPasswordInput);
        }
        if (confirmPasswordInput.value) {
          validateConfirmPassword();
        }
      });
      newPasswordInput.addEventListener('blur', validateNewPassword);
    }

    if (confirmPasswordInput) {
      confirmPasswordInput.addEventListener('blur', validateConfirmPassword);
      confirmPasswordInput.addEventListener('input', () => {
        if (confirmPasswordInput.classList.contains('error')) {
          clearStatus(confirmPasswordInput);
        }
      });
    }

    passwordForm.addEventListener('submit', (e) => {
      e.preventDefault();
      
      const isOldValid = validateOldPassword();
      const isNewValid = validateNewPassword();
      const isConfirmValid = validateConfirmPassword();
      
      if (!isOldValid || !isNewValid || !isConfirmValid) {
        return;
      }
      
      if (changePasswordBtn) {
        setButtonLoading(changePasswordBtn, true, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ...');
      }
      
      passwordForm.submit();
    });
  }
});
