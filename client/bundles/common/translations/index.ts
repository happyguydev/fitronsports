const messages = {
  en: {
    service_request: {
      page_title: 'Which equipment need service?',
    },
    product_order: {
      page_title: 'What do you want to order?',
      product_name: 'Product name *',
      quantity: 'Quantity *',
    },
    cancel_modal_request: {
      page_title: 'Do you want to complete the request another time?',
      description: 'Save as draft to edit or delete it later.',
      save_draft: 'Save as draft',
      delete_request: 'Delete request',
    },
    cancel_modal_report: {
      page_title: 'Do you want to complete your report another time?',
      description: 'Save as draft to edit or delete it later.',
      save_draft: 'Save as draft',
      delete_request: 'Delete report',
    },
    placeholders: {
      title: 'Title *',
      description: 'Description *',
      attachment_note: 'Add a note to your photo',
      search_products: 'Search product *',
      name_of_report: 'Name of your report *',
    },
    actions: {
      cancel: 'Cancel',
      submit: 'Submit',
      create: 'Create',
      update: 'Update',
      delete: 'Delete',
      continue: 'Continue',
      save: 'Save',
      pending: 'Submitting...',
      submitting: 'Submitting...',
      saving: 'Saving...',
      add_photo: 'Add a photo',
      add: 'Add',
      sign_submit: 'Sign and Submit',
    },
    create_report_title: 'Create a new report',
    edit_report_title_facility: 'Edit title and facility',
    part_list: 'Part list',
    add_part: '+ Add part',
    report_title: 'Report title',
    facility_title: 'Facility',
    report_part_editor: {
      page_title: 'Add new part to report',
      edit_page_title: 'Edit or delete part',
      header: 'Inspected part',
      part_name: 'Part name',
      part_description: 'Part description *',
      rate_condition: 'Rate Condition *',
      no_searching_options: 'Sorry, no matching options.',
      sign_your_report: 'Sign your report',
    },
    report_part_rate: {
      good: 'Good',
      problematic: 'Problematic',
      bad: 'Bad',
    },
    common: {
      status: 'Status',
      draft: 'Draft',
      time: 'Time',
      by: 'By',
      mandatory_field_hint: '* means mandatory field here.',
      facility: {
        search_by_name: 'Search by name',
      },
      e_sign_hint: 'Sign here',
      uploading: 'Uploading...',
    },
    image_editor: {
      quit_alert: 'Are you sure to quit editor?',
    },
  },
  de: {
    service_request: {
      page_title: 'Was soll gewartet werden?',
    },
    product_order: {
      page_title: 'Was möchten Sie bestellen?',
      product_name: 'Produktbezeichnung *',
      quantity: 'Anzahl *',
    },
    cancel_modal_request: {
      page_title: 'Wollen Sie die Anfrage abbrechen?',
      description: 'Sie können Ihre Anfrage auch als Entwurf speichern und später ändern oder löschen.',
      save_draft: 'Als Entwurf speichern',
      delete_request: 'Anfrage Löschen',
    },
    cancel_modal_report: {
      page_title: 'Wollen Sie das Erstellen Ihres Prüfberichts wirklich abbrechen?',
      description: 'Sie können Ihren Bericht auch als Entwurf speichern und später ändern oder löschen, sowie Artikel hinzufügen oder entfernen.',
      save_draft: 'Als Entwurf speichern',
      delete_request: 'Prüfbericht löschen',
    },
    placeholders: {
      title: 'Bezeichnung *',
      description: 'Beschreibung *',
      attachment_note: 'Notiz zum Foto hinzufügen',
      search_products: 'Artikel suchen *',
      name_of_report: 'Titel des Prüfberichts *',
    },
    actions: {
      cancel: 'Abbrechen',
      submit: 'Senden',
      create: 'Erstellen',
      update: 'Aktualisieren',
      delete: 'Löschen',
      continue: 'Weiter',
      save: 'Speichern',
      pending: 'Lädt...',
      submitting: 'Lädt...',
      saving: 'Speichert...',
      add_photo: 'Foto hinzufügen',
      add: 'Hinzufügen',
      sign_submit: 'Abschließen',
    },
    create_report_title: 'Neuen Prüfbericht erstellen',
    edit_report_title_facility: 'Titel oder Sportstätte ändern ',
    part_list: 'Artikel',
    add_part: '+ Hinzufügen',
    report_title: 'Titel des Prüfberichts',
    facility_title: 'Sportstätte',
    report_part_editor: {
      page_title: 'Neuen Artikel hinzufügen',
      edit_page_title: 'Artikel ändern oder löschen',
      header: 'Geprüfter Artikel',
      part_name: 'Bezeichnung',
      part_description: 'Beschreibung *',
      rate_condition: 'Zustand *',
      no_searching_options: 'Keine Suchergebnisse',
      sign_your_report: 'Unterschrift',
    },
    report_part_rate: {
      good: 'In Ordnung',
      problematic: 'Reparaturbedürftig',
      bad: 'Beschädigt',
    },
    common: {
      status: 'Status',
      draft: 'Entwurf',
      time: 'Erstellt am',
      by: 'Durchgeführt von',
      facility: {
        search_by_name: 'Suchen',
      },
      e_sign_hint: 'Unterschrift',
      mandatory_field_hint: 'Mit * gekennzeichnete Felder sind verpflichtend',
      uploading: 'Hochladen...',
    },
    image_editor: {
      quit_alert: 'Fotoeditor ohne zu speichern beenden?',
    },
  },
};

export default messages;