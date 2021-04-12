class ReportsMailer < ApplicationMailer
  default from: 'info@fitron.com'

  def send_report (report)
    @report = report
    @facility = @report.facility
    mail(:to => @facility.contact_email, :subject => "Neuer Prüfbericht #{@report.title.titleize} für #{@facility.name.titleize}")
  end
end