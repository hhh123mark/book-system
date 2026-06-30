﻿﻿﻿﻿﻿document.addEventListener('DOMContentLoaded', () => {
  const statusFilter = $('#statusFilter');
  const table = $('#borrowTable');
  const pagination = $('#pagination');

  const getCurrentParams = () => {
    const params = getQueryParams();
    return {
      status: params.status || '',
      pageNo: params.pageNo || '1'
    };
  };

  const updateUrl = (params) => {
    const queryString = buildQueryString(params);
    window.location.href = `${window.location.pathname}?action=list${queryString}`;
  };

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

  const returnButtons = $$('.return-btn');
  returnButtons.forEach(btn => {
    btn.addEventListener('click', async () => {
      const borrowId = btn.dataset.borrowId;
      if (!borrowId) return;

      const confirmed = await showConfirm('\u786e\u8ba4\u5f52\u8fd8\u8fd9\u672c\u56fe\u4e66\u5417\uff1f', '\u5f52\u8fd8\u786e\u8ba4');
      if (!confirmed) return;

      setButtonLoading(btn, true, '\u5f52\u8fd8\u4e2d...');

      try {
        const response = await ajax(getContextPath() + '/borrow', {
          method: 'POST',
          data: {
            action: 'return',
            borrowId: borrowId
          }
        });

        if (response.success) {
          showToast(response.message || '\u5f52\u8fd8\u6210\u529f', 'success');
          setTimeout(() => {
            window.location.reload();
          }, 1000);
        } else {
          showToast(response.message || '\u5f52\u8fd8\u5931\u8d25', 'error');
          setButtonLoading(btn, false);
        }
      } catch (e) {
        showToast(e.message || '\u7f51\u7edc\u9519\u8bef\uff0c\u8bf7\u7a0d\u540e\u91cd\u8bd5', 'error');
        setButtonLoading(btn, false);
      }
    });
  });

  const renewButtons = $$('.renew-btn');
  renewButtons.forEach(btn => {
    btn.addEventListener('click', async () => {
      const borrowId = btn.dataset.borrowId;
      if (!borrowId) return;

      const confirmed = await showConfirm('\u786e\u8ba4\u5ef6\u7eed30\u5929\u5417\uff1f', '\u5ef6\u7eed\u786e\u8ba4');
      if (!confirmed) return;

      setButtonLoading(btn, true, '\u5ef6\u7eed\u4e2d...');

      try {
        const response = await ajax(getContextPath() + '/borrow', {
          method: 'POST',
          data: {
            action: 'renew',
            borrowId: borrowId
          }
        });

        if (response.success) {
          showToast(response.message || '\u5ef6\u7eed\u6210\u529f', 'success');
          setTimeout(() => {
            window.location.reload();
          }, 1000);
        } else {
          showToast(response.message || '\u5ef6\u7eed\u5931\u8d25', 'error');
          setButtonLoading(btn, false);
        }
      } catch (e) {
        showToast(e.message || '\u7f51\u7edc\u9519\u8bef\uff0c\u8bf7\u7a0d\u540e\u91cd\u8bd5', 'error');
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
});
