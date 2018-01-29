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

  var responseFieldHTML = `
    <div class='server_response'>
    </div?
  `

  addAddAddressButton()
  // there should be 1 field at intiial page load
  addAddAddressHTML()
  addInputField()
  addSubmitButton()
  addMixedAddressHTML()
  addServerResponseField()

  // =========listeners============
  $(coinFormWrapper).on('click', '.remove_address_button', function(e) {
    removeInputRow.call(this)
  });

  $(coinFormWrapper).on('click', '.add_address_button', function(e) {
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
      addInputField();
      var next_inbox_index = $('.address_field').index(this) + 1;
      $('.address_field input[type=text]')[next_inbox_index].focus()
    }
  });


  // =============reuseable functions============
  function addInputField() {
    $('.add_address_section').append(inputHTML);
  }

  function addAddAddressButton() {
    $(coinFormWrapper).append(addAddressButton);
  }

  function addAddAddressHTML() {
    $(coinFormWrapper).append(addAddressHTML)
  }

  function addMixedAddressHTML() {
    $(coinFormWrapper).append(mixedAddressHTML)
  }

  function addServerResponseField() {
    $(coinFormWrapper).append(responseFieldHTML)
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

  function displayServerResponse(data) {
    $('.server_response').html($.map(data, function(val, key) { return val; })[0])
  }

  function submitForm(e) {
    e.preventDefault();

    var addresses = $('.add_address_section .add_address_field').map(function() { return $(this).val() }).get();

    $.ajax({
      type: 'POST',
      url: '/mix_addresses',
      //grab the inputs from address_section
      data: { 'addresses': addresses },
      dataType: "json",
      success: function(data) {
        $('.mixed_address_html').append(`This is your new mixed address: ${data['mixed_address']}`)
        addDepositField()
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
        displayServerResponse(data)
      }
    });
  }
});
