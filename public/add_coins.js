$(function(){
  var coin_form_wrapper = $(".coin-form-wrapper");
  var submit_address_button = $('.add_address_button');
  var input_html = `
    <div>
      <input type='text' class='add_address_field' name='field_name[]' value=""/>
      <input type='button' class='remove_address_button' value='Remove Address'/>
    </div>
  `;
  var addAddressButton = `
    <div class='add_address'>
      <input type='button' class='add_address_button' value='Add Another Address'/>
    </div>
  `

  addAddAddressButton()

  // there should be 1 field at intiial page load
  add_input_field()

  // =========listeners============
  $(coin_form_wrapper).on('click', '.remove_address_button', function(e) {
    remove_input_row.call(this)
  });

  $(coin_form_wrapper).on('click', '.add_address_button', function(e) {
    add_input_field()
  });

  $(submit_address_button).click(function(e) {
    submit_form()
  })


  // reuseable functions
  function add_input_field() {
    $(coin_form_wrapper).append(input_html);
  }

  function addAddAddressButton() {
    $(coin_form_wrapper).append(addAddressButton)
  }

  function remove_input_row(e) {
    $(this).parent('div').remove();
  }

  function submit_form() {
    e.preventDefault();
  }
});
