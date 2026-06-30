﻿﻿﻿﻿﻿document.addEventListener('DOMContentLoaded', () => {
  const searchForm = $('#searchForm');
  const statusFilter = $('#statusFilter');

  const getCurrentParams = () => {
    const params = getQueryParams();
    return {
      keyword: params.keyword || '',
      status: params.status || '',
      pageNo: params.pageNo || '1'
    };
  };

  const updateUrl = (params) => {
    const queryString = buildQueryString(params);
    window.location.href = `/admin/user?action=list${queryString}`;
  };

  if (searchForm) {
    searchForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const keywordInput = $('#keyword');
      const params = getCurrentParams();
      params.keyword = keywordInput ? keywordInput.value.trim() : '';
      params.pageNo = '1';
      updateUrl(params);
    });
  }

  if (statusFilter) {
    statusFilter.addEventListener('change', () => {
      const params = getCurrentParams();
      params.status = statusFilter.value;
      params.pageNo = '1';
      updateUrl(params);
    });
  }

  handlePagination('#pagination', (page) => {
    const params = getCurrentParams();
    params.pageNo = String(page);
    updateUrl(params);
  });

  const statusButtons = $$('.status-toggle');
  statusButtons.forEach(btn => {
    btn.addEventListener('click', async () => {
      const userId = btn.dataset.id;
      const currentStatus = btn.dataset.status;
      const newStatus = currentStatus === '1' ? '0' : '1';
      
      const action = newStatus === '1' ? ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ' : ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ';
      const confirmed = await showConfirm(` '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ${action} '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ？`, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
      if (!confirmed) return;

      setButtonLoading(btn, true, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ...');

      try {
        const response = await ajax('/admin/user', {
          method: 'POST',
          data: {
            action: 'updateStatus',
            id: userId,
            status: newStatus
          }
        });

        if (response.success) {
          showToast(response.message || ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'success');
          setTimeout(() => {
            window.location.reload();
          }, 1000);
        } else {
          showToast(response.message || ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'error');
          setButtonLoading(btn, false);
        }
      } catch (e) {
        showToast(e.message || ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'error');
        setButtonLoading(btn, false);
      }
    });
  });

  const deleteButtons = $$('.delete-btn');
  deleteButtons.forEach(btn => {
    btn.addEventListener('click', async (e) => {
      e.preventDefault();
      const userId = btn.dataset.id;
      if (!userId) return;

      const confirmed = await showConfirm(' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ？ '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value 。', ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
      if (!confirmed) return;

      showLoading();

      try {
        window.location.href = `/admin/user?action=delete&id=${userId}`;
      } catch (e) {
        hideLoading();
        showToast(' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'error');
      }
    });
  });

  handleTableSort('#userTable', (field, order) => {
    const params = getCurrentParams();
    params.sortField = field;
    params.sortOrder = order;
    params.pageNo = '1';
    updateUrl(params);
  });
});
