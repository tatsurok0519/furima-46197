// turbo:loadイベントは、ページの初回読み込み時やTurboによるページ遷移時に発火します
document.addEventListener('turbo:load', () => {
  // 手順2: 必要な要素を取得する
  const priceInput = document.getElementById("item-price");
  const addTaxPrice = document.getElementById("add-tax-price");
  const profit = document.getElementById("profit");

  // 価格入力欄が存在しないページでは、処理を実行しないようにする
  if (!priceInput) {
    return;
  }

  // 手順6: 計算と描画の処理を関数にまとめる
  const render = () => {
    // 手順4: 入力された値を取得し、数値に変換する
    const inputValue = parseInt(priceInput.value, 10);

    // 入力値が数値でない(NaN)場合は、計算せずに表示を空にする
    if (isNaN(inputValue) || inputValue < 0) { // マイナスの値も考慮
      addTaxPrice.innerHTML = "";
      profit.innerHTML = "";
      return;
    }

    // 手順5: 計算と描画
    const commission = Math.floor(inputValue * 0.1);
    addTaxPrice.innerHTML = commission.toLocaleString(); // 3桁区切りで見やすくする
    profit.innerHTML = (inputValue - commission).toLocaleString();
  };

  // 手順3 & 6: 入力イベントに関数を紐付ける
  priceInput.addEventListener("input", render);
});