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

  addAddAddressButton()
  // there should be 1 field at intiial page load
  addAddAddressHTML()
  addInputField()
  addSubmitButton()

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


  // reuseable functions
  function addInputField() {
    $('.add_address_section').append(inputHTML);
  }

  function addAddAddressButton() {
    $(coinFormWrapper).append(addAddressButton);
  }

  function addAddAddressHTML() {
    $(coinFormWrapper).append(addAddressHTML)
  }

  function removeInputRow(e) {
    $(this).parent('div').remove();
  }

  function addSubmitButton() {
    $(coinFormWrapper).append(submitButton);
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
        debugger;
      }
    });
  }
});
