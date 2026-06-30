﻿﻿﻿﻿﻿document.addEventListener('DOMContentLoaded', () => {
  const addForm = $('#addCategoryForm');
  const editForm = $('#editCategoryForm');
  const addModalTrigger = $('#addCategoryBtn');
  const editButtons = $$('.edit-btn');
  const deleteButtons = $$('.delete-btn');

  let currentEditId = null;

  const validateForm = (form) => {
    const nameInput = form.querySelector('#name');
    const sortOrderInput = form.querySelector('#sortOrder');
    let isValid = true;

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

    if (nameInput) {
      const value = nameInput.value.trim();
      if (Validator.isEmpty(value)) {
        showError(nameInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
        isValid = false;
      } else if (!Validator.maxLength(value, 50)) {
        showError(nameInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value 50 '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
        isValid = false;
      } else {
        showSuccess(nameInput);
      }
    }

    if (sortOrderInput && sortOrderInput.value) {
      const value = sortOrderInput.value;
      if (!Validator.isInt(value)) {
        showError(sortOrderInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
        isValid = false;
      } else {
        showSuccess(sortOrderInput);
      }
    }

    return isValid;
  };

  const setupInputValidation = (form) => {
    const nameInput = form.querySelector('#name');
    const sortOrderInput = form.querySelector('#sortOrder');

    if (nameInput) {
      nameInput.addEventListener('input', () => {
        if (nameInput.classList.contains('error')) {
          nameInput.classList.remove('error');
          const formGroup = nameInput.closest('.form-group');
          const errorText = formGroup?.querySelector('.form-text');
          if (errorText) errorText.remove();
        }
      });
    }

    if (sortOrderInput) {
      sortOrderInput.addEventListener('input', () => {
        if (sortOrderInput.classList.contains('error')) {
          sortOrderInput.classList.remove('error');
          const formGroup = sortOrderInput.closest('.form-group');
          const errorText = formGroup?.querySelector('.form-text');
          if (errorText) errorText.remove();
        }
      });
    }
  };

  const addModal = Modal.create({
    title: ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ',
    content: `
      <form id="addCategoryForm">
        <div class="form-group">
          <label class="form-label"> '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  <span class="text-danger">*</span></label>
          <input type="text" id="name" name="name" class="form-control" placeholder=" '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ">
        </div>
        <div class="form-group">
          <label class="form-label"> '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value </label>
          <textarea id="description" name="description" class="form-control" rows="3" placeholder=" '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value "></textarea>
        </div>
        <div class="form-group">
          <label class="form-label"> '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value </label>
          <input type="number" id="sortOrder" name="sortOrder" class="form-control" placeholder=" '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value " value="0">
        </div>
      </form>
    `,
    confirmText: ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ',
    cancelText: ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ',
    onConfirm: () => {
      const form = document.getElementById('addCategoryForm');
      if (!validateForm(form)) {
        return false;
      }
      
      const formData = new FormData(form);
      const data = {};
      formData.forEach((value, key) => {
        data[key] = value;
      });
      data.action = 'add';
      
      addModal.hide();
      showLoading();
      
      const submitForm = document.createElement('form');
      submitForm.method = 'POST';
      submitForm.action = '/admin/category';
      
      Object.keys(data).forEach(key => {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = key;
        input.value = data[key];
        submitForm.appendChild(input);
      });
      
      const csrfToken = getCsrfToken();
      if (csrfToken) {
        const csrfInput = document.createElement('input');
        csrfInput.type = 'hidden';
        csrfInput.name = 'csrfToken';
        csrfInput.value = csrfToken;
        submitForm.appendChild(csrfInput);
      }
      
      document.body.appendChild(submitForm);
      submitForm.submit();
      
      return false;
    }
  });

  if (addModalTrigger) {
    addModalTrigger.addEventListener('click', () => {
      addModal.show();
      setupInputValidation(document.getElementById('addCategoryForm'));
    });
  }

  const editModal = Modal.create({
    title: ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ',
    content: `
      <form id="editCategoryForm">
        <input type="hidden" id="editId" name="id">
        <div class="form-group">
          <label class="form-label"> '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  <span class="text-danger">*</span></label>
          <input type="text" id="name" name="name" class="form-control" placeholder=" '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ">
        </div>
        <div class="form-group">
          <label class="form-label"> '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value </label>
          <textarea id="description" name="description" class="form-control" rows="3" placeholder=" '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value "></textarea>
        </div>
        <div class="form-group">
          <label class="form-label"> '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value </label>
          <input type="number" id="sortOrder" name="sortOrder" class="form-control" placeholder=" '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ">
        </div>
      </form>
    `,
    confirmText: ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ',
    cancelText: ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ',
    onConfirm: () => {
      const form = document.getElementById('editCategoryForm');
      if (!validateForm(form)) {
        return false;
      }
      
      editModal.hide();
      showLoading();
      
      form.method = 'POST';
      form.action = '/admin/category';
      
      const actionInput = document.createElement('input');
      actionInput.type = 'hidden';
      actionInput.name = 'action';
      actionInput.value = 'update';
      form.appendChild(actionInput);
      
      form.submit();
      
      return false;
    }
  });

  editButtons.forEach(btn => {
    btn.addEventListener('click', async () => {
      const categoryId = btn.dataset.id;
      if (!categoryId) return;

      showLoading();

      try {
        const response = await ajax(`/admin/category?action=edit&id=${categoryId}`);
        
        if (response.success && response.data) {
          const data = response.data;
          const form = document.getElementById('editCategoryForm');
          
          if (form) {
            form.querySelector('#editId').value = data.id || '';
            form.querySelector('#name').value = data.name || '';
            form.querySelector('#description').value = data.description || '';
            form.querySelector('#sortOrder').value = data.sortOrder !== undefined ? data.sortOrder : 0;
          }
          
          hideLoading();
          editModal.show();
          setupInputValidation(form);
        } else {
          hideLoading();
          showToast(response.message || ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'error');
        }
      } catch (e) {
        hideLoading();
        showToast(e.message || ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'error');
      }
    });
  });

  deleteButtons.forEach(btn => {
    btn.addEventListener('click', async (e) => {
      e.preventDefault();
      const categoryId = btn.dataset.id;
      if (!categoryId) return;

      const confirmed = await showConfirm(' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ？ '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value 。', ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
      if (!confirmed) return;

      showLoading();

      try {
        const response = await ajax('/admin/category', {
          method: 'POST',
          data: {
            action: 'delete',
            id: categoryId
          }
        });

        hideLoading();

        if (response.success) {
          showToast(response.message || ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'success');
          setTimeout(() => {
            window.location.reload();
          }, 1000);
        } else {
          showToast(response.message || ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'error');
        }
      } catch (e) {
        hideLoading();
        showToast(e.message || ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'error');
      }
    });
  });
});
