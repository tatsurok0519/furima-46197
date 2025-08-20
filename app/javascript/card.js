const pay = () => {
  const form = document.getElementById('charge-form');
  if (!form || form.getAttribute('data-payjp-initialized')) {
    return;
  }
  form.setAttribute('data-payjp-initialized', 'true');
  
  // 公開鍵が設定されていない場合はエラーを出力して処理を終了
  const publicKey = window.gon?.public_key;
  if (!publicKey) {
    console.error('Pay.jp public key is not set. Make sure to set gon.public_key in your controller.');
    return;
  }
  const payjp = Payjp(publicKey);
  const elements = payjp.elements();
  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement = elements.create('cardCvc');

  numberElement.mount('#number-form');
  expiryElement.mount('#expiry-form');
  cvcElement.mount('#cvc-form');

  form.addEventListener("submit", (e) => {
    e.preventDefault();

    const submitButton = form.querySelector('input[type="submit"]');
    submitButton.disabled = true;
  
    payjp.createToken(numberElement).then(function (response) {
      if (response.error) {
        // エラーメッセージをアラートで表示
        alert(response.error.message);
        submitButton.disabled = false;
      } else {
        const token = response.id;
        const tokenObj = `<input value=${token} name='token' type="hidden">`;
        form.insertAdjacentHTML("beforeend", tokenObj);
      
        numberElement.clear();
        expiryElement.clear();
        cvcElement.clear();
        form.submit();
      }
    });
  });
};

window.addEventListener("turbo:load", pay);
window.addEventListener("turbo:render", pay);