﻿﻿﻿﻿﻿document.addEventListener('DOMContentLoaded', () => {
  const searchForm = $('#searchForm');
  const statusFilter = $('#statusFilter');

  const getCurrentParams = () => {
    const params = getQueryParams();
    return {
      keyword: params.keyword || '',
      status: params.status !== undefined && params.status !== '' ? params.status : '',
      pageNo: params.pageNo || '1'
    };
  };

  const updateUrl = (params) => {
    const queryString = buildQueryString(params);
    window.location.href = `/admin/borrow?action=list${queryString}`;
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

  const returnButtons = $$('.confirm-return-btn');
  returnButtons.forEach(btn => {
    btn.addEventListener('click', async () => {
      const borrowId = btn.dataset.borrowId;
      if (!borrowId) return;

      const confirmed = await showConfirm(' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ？', ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
      if (!confirmed) return;

      setButtonLoading(btn, true, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ...');

      try {
        const response = await ajax('/admin/borrow', {
          method: 'POST',
          data: {
            action: 'return',
            borrowId: borrowId
          }
        });

        if (response.success) {
          showToast(response.message || ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'success');
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

  handleTableSort('#borrowTable', (field, order) => {
    const params = getCurrentParams();
    params.sortField = field;
    params.sortOrder = order;
    params.pageNo = '1';
    updateUrl(params);
  });

  const exportBtn = $('#exportBtn');
  if (exportBtn) {
    exportBtn.addEventListener('click', () => {
      const params = getCurrentParams();
      const queryString = buildQueryString(params);
      window.location.href = `/export?type=borrow${queryString}`;
    });
  }
});
