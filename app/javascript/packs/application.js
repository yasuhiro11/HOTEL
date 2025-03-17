import Rails from "@rails/ujs";
Rails.start();

import flatpickr from "flatpickr";
import "flatpickr/dist/themes/material_blue.css"; // カレンダーのテーマ
import { Japanese } from "flatpickr/dist/l10n/ja.js";

document.addEventListener("DOMContentLoaded", () => {
    // チェックインとチェックアウトの入力にFlatpickrを適用
    const checkInInput = document.getElementById("check-in");
    const checkOutInput = document.getElementById("check-out");
    const checkOutError = document.getElementById("check-out-error");
  
    if (checkInInput) {
      const checkInPicker = flatpickr(checkInInput, {
        altInput: true,
        altFormat: "Y/m/d",
        dateFormat: "Y-m-d",
        minDate: "today",
        locale: Japanese,
        onChange: function (selectedDates) {
          if (selectedDates.length > 0 && checkOutInput) {
            checkOutPicker.set("minDate", selectedDates[0]);
          }
        },
      });
  
      if (checkOutInput) {
        const checkOutPicker = flatpickr(checkOutInput, {
          altInput: true,
          altFormat: "Y/m/d",
          dateFormat: "Y-m-d",
          minDate: "today",
          locale: Japanese,
        });
  
        const validateDates = () => {
          const checkInDate = new Date(checkInInput.value);
          const checkOutDate = new Date(checkOutInput.value);
  
          if (
            checkInInput.value &&
            checkOutInput.value &&
            checkOutDate <= checkInDate
          ) {
            checkOutError.style.display = "block"; // エラーメッセージを表示
            checkOutInput.value = ""; // チェックアウトの値をリセット
          } else {
            checkOutError.style.display = "none"; // エラーメッセージを非表示
          }
        };
  
        checkInInput.addEventListener("change", validateDates);
        checkOutInput.addEventListener("change", validateDates);
      }
    }
  });

// ログアウトリンクのクリックイベント処理
document.addEventListener("DOMContentLoaded", () => {
  const logoutLink = document.querySelector(".logout-link");

  if (logoutLink) {
    logoutLink.addEventListener("click", (event) => {
      event.preventDefault();

      // 動的にフォームを生成して DELETE リクエストを送信
      const form = document.createElement("form");
      form.method = "POST";
      form.action = logoutLink.href;

      // DELETE メソッドを指定
      const methodInput = document.createElement("input");
      methodInput.type = "hidden";
      methodInput.name = "_method";
      methodInput.value = "delete";
      form.appendChild(methodInput);

      // CSRF トークンを追加
      const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
      const csrfInput = document.createElement("input");
      csrfInput.type = "hidden";
      csrfInput.name = "authenticity_token";
      csrfInput.value = csrfToken;
      form.appendChild(csrfInput);

      // フォームを送信
      document.body.appendChild(form);
      form.submit();
    });
  }
});