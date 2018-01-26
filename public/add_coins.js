$(function(){
  var coin_form_wrapper = $(".coin-form-wrapper")
  var submit_address_button = $('.add_address_button')
  var inputHTML = `
    <div>
      <input type='text' class='add_address_field' name='field_name[]' value=""/>
      <input type='button' class='remove_address_button' value='Remove Address'/>
    </div>
  `;

  $(coin_form_wrapper).append(inputHTML);

  $(coin_form_wrapper).on('click', '.remove_address_button', function(e){
    e.preventDefault();
    $(this).parent('div').remove();
  });

  $(submit_address_button).click(function(e) {
    // without this, it'll try to submit the form. I always forget this.
    e.preventDefault();
  })
});
