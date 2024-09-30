document.addEventListener("turbo:load", () => {
  const filterForm = document.getElementById("filter-form");

  if (filterForm) {
    filterForm.addEventListener("ajax:success", (event) => {
      const [data, status, xhr] = event.detail;
      const table = document.getElementById("products-table");

      if (table) {
        table.innerHTML = xhr.response;
      }
    });

    filterForm.addEventListener("ajax:error", (event) => {
      console.error("Ошибка при фильтрации", event.detail);
    });
  }
});
