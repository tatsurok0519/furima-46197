const priceCalculator = () => {
  const priceInput = document.getElementById("item-price");

  if (!priceInput) {
    return;
  }

  const addTaxPrice = document.getElementById("add-tax-price");
  const profit = document.getElementById("profit");

  const render = () => {
    const inputValue = parseInt(priceInput.value, 10);

    if (isNaN(inputValue) || inputValue < 0) {
      addTaxPrice.innerHTML = "";
      profit.innerHTML = "";
      return;
    }

    const commission = Math.floor(inputValue * 0.1);
    addTaxPrice.innerHTML = commission.toLocaleString();
    profit.innerHTML = (inputValue - commission).toLocaleString();
  };

  priceInput.addEventListener("input", render);
};

document.addEventListener('turbo:load', priceCalculator);
document.addEventListener('turbo:render', priceCalculator);