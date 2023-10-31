//= require rails-ujs

function exportTableToCSV(target, filename) {
  var table = document.querySelector(target);

  var data = []
  table.querySelectorAll("tr").forEach(row => {
    data.push(Array.from(row.querySelectorAll("td,th")).map(cell => {
      if (cell.dataset.fieldValue.indexOf(',') > -1) {
        return `"${cell.dataset.fieldValue}"`
      } else {
        return cell.dataset.fieldValue
      }
    }).join(","))
  })

  downloadCSV(data.join("\n"), filename);
}

function downloadCSV(csvData, filename) {
  let csvFile = new Blob([csvData], {type: "text/csv"})

  let lnk = document.createElement("a");
  lnk.download = filename;
  lnk.href = window.URL.createObjectURL(csvFile);
  lnk.style.display = "none";

  document.body.append(lnk);

  lnk.click();

  lnk.remove();
}
