$(function(){
  var coinFormWrapper = $(".coin-form-wrapper");
  var submitAddressButton = $('.add_address_button');
  var inputHTML = `
    <div class='address_field'>
      <input type='text' class='add_address_field' name='field_name[]' value=""/>
      <input type='button' class='remove_address_button' value='Remove Address'/>
    </div>
  `;
  var addAddressButton = `
    <div class='add_address'>
      <input type='button' class='add_address_button' value='Add Another Address'/>
    </div>
  `
  var submitButton = `
    <div class='submit_address'>
      <input type='button' class='submit_button' value='Mix Addresses'/>
    </div>
  `
  var addAddressHTML = `
    <div class='add_address_section'>
    </div>
  `

  var mixedAddressHTML = `
    <div class='mixed_address_html'>
    </div>
  `

  var depositHTML = `
    <div class='deposit_field'>
      <div class='deposit_from'
        <label>Deposit From:</label>
        <input type='text' value=''/>
      </div>

      <div class='deposit_to'
        <label>Deposit To:</label>
        <input type='text' value=""/>
      </div>

      <div class='deposit_amount'
        <label>Deposit Amount:</label>
        <input type='text' value=""/>
      </div>

      <input type='button' class='deposit_button' value='Deposit'/>
    </div>
  `

  var ResponseHTML = `
    <div class='response_field'>
    </div?
  `

  addAddAddressButton()
  addAddAddressField()
  addInputField()
  addSubmitButton()
  addResponseField()
  addMixedAddressField()


  // =========listeners============
  $(coinFormWrapper).on('click', '.remove_address_button', function(e) {
    removeInputRow.call(this)
  });

  $(coinFormWrapper).on('click', '.add_address_button', function(e) {
    e.preventDefault();
    addInputField()
  });

  $(coinFormWrapper).on('click', '.submit_button', function(e) {
    submitForm(e)
  });

  $(coinFormWrapper).on('click', '.deposit_button', function(e) {
    depositCoin(e)
  });

  $('.add_address_section').on('keyup', '.address_field', function (e) {
    if (e.keyCode == 13) {
      e.preventDefault();
      addInputField()
    }
  });


  // =============reuseable functions============
  function addInputField() {
    clearResponseHTML()
    if ($(".add_address_section > .address_field").find('input[type=text]:empty').filter(function () { return this.value.length == 0}).length > 0) {
      $('.response_field').html("You already have an empty address box. Fill that in first.")
      $(".add_address_section > .address_field").find('input[type=text]:empty').filter(function () { return this.value.length == 0}).focus()
    } else {
      $('.add_address_section').append(inputHTML);
      $(".add_address_section > .address_field").find('input[type=text]:empty').filter(function () { return this.value.length == 0}).focus()
    }
  }

  function addAddAddressButton() {
    $(coinFormWrapper).append(addAddressButton);
  }

  function addAddAddressField() {
    $(coinFormWrapper).append(addAddressHTML)
  }

  function addMixedAddressField() {
    $(coinFormWrapper).append(mixedAddressHTML)
  }

  function addResponseField() {
    $(coinFormWrapper).append(ResponseHTML)
  }

  function clearResponseHTML() {
    $('.response_field').empty();
  }

  function removeInputRow() {
    $(this).parent('div').remove();
  }

  function addSubmitButton() {
    $(coinFormWrapper).append(submitButton);
  }

  function addDepositField() {
    $(coinFormWrapper).append(depositHTML)
  }

  function displayDepositComplete(data) {
    clearResponseHTML()
    if ($.map(data, function(val, key) { return val; })[0] == 'OK') {
      var message = 'DEPOSIT COMPLETE!'
    } else {
      var message = 'Something went wrong. Try again?'
    }
    debugger;
    $('.response_field').html(message)
  }

  function displayMixedAddress(data) {
    $('.mixed_address_html').empty()
    $('.mixed_address_html').html(`This is your new mixed address: ${data['mixed_address']}`)
  }

  function submitForm(e) {
    e.preventDefault();

    clearResponseHTML()

    if ($(".add_address_section > .address_field").find('input[type=text]:empty').filter(function () { return this.value.length == 0}).length > 0) {
      $(".add_address_section > .address_field").last().remove()
    }

    var addresses = $('.add_address_section .add_address_field').map(function() { return $(this).val() }).get();

    $.ajax({
      type: 'POST',
      url: '/mix_addresses',
      //grab the inputs from address_section
      data: { 'addresses': addresses },
      dataType: "json",
      success: function(data) {
        displayMixedAddress(data)

        // only need one of those deposit forms
        if ($(".deposit_field").length == 0) {
          addDepositField()
        }

        // auto set the deposit_to field for convenience
        $('.deposit_to input').val(data["mixed_address"])
      }
    });
  }

  function depositCoin(e) {
    e.preventDefault();

    var addressFrom = $('.deposit_from input').val()
    var addressTo = $('.deposit_to input').val()
    var depositAmount = $('.deposit_amount input').val()

    $.ajax({
      type: 'POST',
      url: '/deposit',
      data: { 'amount': depositAmount, 'address_from': addressFrom, 'address_to': addressTo },
      dataType: "json",
      success: function(data) {
        displayDepositComplete(data)
      }
    });
  }
});
