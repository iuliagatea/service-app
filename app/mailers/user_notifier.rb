class UserNotifier < ApplicationMailer
  default :from => 'do-not-reply@fixit.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_status_change_email_pdf(user, product, subject)
    @user = user
    @product = product
    @product_statuses = @product.product_statuses
    @estimates = @product.estimates
    test = WickedPdf.new.pdf_from_string(
      render_to_string(
          pdf: "test.pdf",
          template: "products/product_pdf_to_send.html.erb",
          layout: 'layouts/pdf.html.erb'
         )
    )

    attachments["#{@product.code}_product_card.pdf"] = test
    mail to: @user.email, subject: subject
  end
  def send_status_change_email(user, product, subject)
    @user = user
    @product = product
    @product_statuses = @product.product_statuses
    @estimates = @product.estimates
    mail to: @user.email, subject: subject
  end
end
