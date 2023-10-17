abstract class Schema {
  final Map<String, dynamic> formSchema;
  final Map<String, dynamic> uiSchema;
  final Map<String, dynamic>? formData;

  Schema({required this.formSchema, required this.uiSchema, this.formData});
}

class ImageSchema extends Schema {
  ImageSchema()
      : super(
          formSchema: {
            "title": "A registration form",
            "description": "A simple form example.",
            "type": "object",
            "required": [],
            "properties": {
              "image_widget_test": {
                "type": "integer",
                "title": "Test",
                "enum": ['1', '2', '3', '4', '5', '6'],
                "enumNames": ["One", "Two", "Three", 'Four', 'Five', 'Six']
              },
            }
          },
          uiSchema: {
            "image_widget_test": {
              "ui:widget": "image",
              "ui:options": {
                "text": "Test text",
                "images": [
                  "https://picsum.photos/200",
                  "https://picsum.photos/200",
                  "https://picsum.photos/200",
                  "https://picsum.photos/200",
                  "https://picsum.photos/200",
                  "https://picsum.photos/200",
                  "https://picsum.photos/200",
                  "https://picsum.photos/200",
                  "https://picsum.photos/200"
                ]
              }
            },
          },
        );
}

class BigSchema extends Schema {
  BigSchema()
      : super(formSchema: {
          "type": "object",
          "properties": {
            "back_to_observer": {
              "enum": ["yes", "no"],
              "title": "Should the form be sent back to the observer?",
              "type": "string",
              "enumNames": ["yes", "no"]
            }
          },
          "dependencies": {
            "back_to_observer": {
              "oneOf": [
                {
                  "properties": {
                    "back_to_observer": {
                      "enum": ["yes"]
                    },
                    "note": {"title": "Note to observer", "type": "string"}
                  },
                  "required": ["note"]
                },
                {
                  "properties": {
                    "back_to_observer": {
                      "enum": ["no"]
                    },
                    "name": {"title": "Full Name", "type": "string"},
                    "phone_number_signal": {"title": "Phone number (signal)", "type": "string"},
                    "phone_number_poland": {"title": "Phone number in Poland", "type": "string"},
                    "observation_spot": {
                      "title": "District/city you will observe in",
                      "type": "string"
                    },
                    "1a": {
                      "title": "Opening procedures",
                      "type": "object",
                      "description":
                          "1a. Were all the necessary election materials present? Check the following items:",
                      "properties": {
                        "1a_polling_booth": {"title": "Polling booth/s", "type": "boolean"},
                        "1a_ballot_papers": {"title": "Ballot papers", "type": "boolean"},
                        "1a_voters_list": {"title": "Voters lists", "type": "boolean"},
                        "1a_protocols": {"title": "Protocols", "type": "boolean"},
                        "1a_ballot_box_seals": {"title": "Ballot box seals", "type": "boolean"},
                        "1a_ballot_box": {"title": "Ballot box(es)", "type": "boolean"},
                        "1a_stamps": {"title": "Stamp", "type": "boolean"},
                        "1a_data_protection_sheet": {
                          "title": "Data Protection Sheet",
                          "type": "boolean"
                        },
                        "1a_other": {"title": "Other (comment below)", "type": "boolean"}
                      },
                      "dependencies": {
                        "1a_other": {
                          "oneOf": [
                            {
                              "properties": {
                                "1a_other": {
                                  "enum": [true]
                                },
                                "1a_note": {"title": "Place for comment", "type": "string"},
                                "1a_files": {"title": "Attach needed files", "type": "string"}
                              },
                              "required": []
                            },
                            {
                              "properties": {
                                "1a_other": {
                                  "enum": [false]
                                }
                              },
                              "required": []
                            }
                          ]
                        }
                      },
                      "required": []
                    },
                    "2a": {
                      "enum": ["yes", "no", "not_applicable"],
                      "title":
                          "2a. Did the PSO members stamp the ballot papers during the preparation?",
                      "type": "string",
                      "enumNames": ["yes", "no", "not applicable"]
                    },
                    "3a": {
                      "enum": ["yes", "no", "not_applicable"],
                      "title":
                          "3a. Was the number of voters in the general voting lists announced and entered into a protocol?",
                      "type": "string",
                      "enumNames": ["yes", "no", "not applicable"]
                    },
                    "4a": {
                      "enum": ["yes", "no", "not_applicable"],
                      "title": "4a. Were the packages of ballots and envelopes intact?",
                      "type": "string",
                      "enumNames": ["yes", "no", "not applicable"]
                    },
                    "5a": {
                      "enum": ["yes", "no", "not_applicable"],
                      "title":
                          "5a. Was the number of ballot papers announced and entered into the protocols?",
                      "type": "string",
                      "enumNames": ["yes", "no", "not applicable"]
                    },
                    "6a": {
                      "enum": ["yes", "no", "not_applicable"],
                      "title": "6a. Were the ballot boxes properly sealed?",
                      "type": "string",
                      "enumNames": ["yes", "no", "not applicable"]
                    },
                    "7a": {
                      "enum": ["yes", "no", "not_applicable"],
                      "title":
                          "7a. Were the serial numbers of the ballot box seals entered into a record book?",
                      "type": "string",
                      "enumNames": ["yes", "no", "not applicable"]
                    },
                    "8a": {
                      "enum": ["yes", "no", "not_applicable"],
                      "title": "8a. Were information notices posted around the PS?",
                      "type": "string",
                      "enumNames": ["yes", "no", "not applicable"]
                    },
                    "9a": {
                      "enum": ["yes", "no", "not_applicable"],
                      "title": "9a. Did the polling station open on time?",
                      "type": "string",
                      "enumNames": ["yes", "no", "not applicable"]
                    },
                    "10a": {
                      "title":
                          "10a. Were unauthorised persons present at the opening of this PS? Did you see:",
                      "type": "object",
                      "description": "",
                      "properties": {
                        "10a_uninvited_police": {"title": "Uninvited police", "type": "boolean"},
                        "10a_local_officials": {"title": "Local official(s)", "type": "boolean"},
                        "10a_state_officials": {"title": "State officials", "type": "boolean"},
                        "10a_military": {"title": "Military", "type": "boolean"},
                        "10a_candidate": {"title": "Candidate(s)", "type": "boolean"},
                        "10a_party_activist": {"title": "Party activist(s)", "type": "boolean"},
                        "10a_other": {"title": "Other (comment below)", "type": "boolean"}
                      },
                      "dependencies": {
                        "10a_uninvited_police": {
                          "oneOf": [
                            {
                              "properties": {
                                "10a_uninvited_police": {
                                  "enum": [true]
                                },
                                "10a_police_why": {
                                  "title": "What is the reason for their presence on the PS?",
                                  "type": "string"
                                }
                              },
                              "required": []
                            },
                            {
                              "properties": {
                                "10a_uninvited_police": {
                                  "enum": [false]
                                }
                              },
                              "required": []
                            }
                          ]
                        },
                        "10a_local_officials": {
                          "oneOf": [
                            {
                              "properties": {
                                "10a_local_officials": {
                                  "enum": [true]
                                },
                                "10a_which_local_officials": {
                                  "type": "string",
                                  "title":
                                      "Which officials are they? What is the reason for their presence in the polling station?"
                                }
                              },
                              "required": []
                            },
                            {
                              "properties": {
                                "10a_local_officials": {
                                  "enum": [false]
                                }
                              },
                              "required": []
                            }
                          ]
                        },
                        "10a_state_officials": {
                          "oneOf": [
                            {
                              "properties": {
                                "10a_state_officials": {
                                  "enum": [true]
                                },
                                "10a_which_state_officials": {
                                  "title":
                                      "Which officials are they? What is the reason for their presence on the PS?",
                                  "type": "string"
                                }
                              },
                              "required": []
                            },
                            {
                              "properties": {
                                "10a_state_officials": {
                                  "enum": [false]
                                }
                              },
                              "required": []
                            }
                          ]
                        },
                        "10a_military": {
                          "oneOf": [
                            {
                              "properties": {
                                "10a_military": {
                                  "enum": [true]
                                },
                                "10a_military_why": {
                                  "title": "What is the reason for their presence on the PS?",
                                  "type": "string"
                                }
                              },
                              "required": []
                            },
                            {
                              "properties": {
                                "10a_military": {
                                  "enum": [false]
                                }
                              },
                              "required": []
                            }
                          ]
                        },
                        "10a_candidate": {
                          "oneOf": [
                            {
                              "properties": {
                                "10a_candidate": {
                                  "enum": [true]
                                },
                                "10a_which_candidate": {
                                  "title":
                                      "Which candidates are they? What is the reason for their presence on the PS?",
                                  "type": "string"
                                }
                              },
                              "required": []
                            },
                            {
                              "properties": {
                                "10a_candidate": {
                                  "enum": [false]
                                }
                              },
                              "required": []
                            }
                          ]
                        },
                        "10a_party_activist": {
                          "oneOf": [
                            {
                              "properties": {
                                "10a_party_activist": {
                                  "enum": [true]
                                },
                                "10a_which_party_activist": {
                                  "title":
                                      "Which party activists are they? What is the reason for their presence on the PS?",
                                  "type": "string"
                                }
                              },
                              "required": []
                            },
                            {
                              "properties": {
                                "10a_party_activist": {
                                  "enum": [false]
                                }
                              },
                              "required": []
                            }
                          ]
                        },
                        "10a_other": {
                          "oneOf": [
                            {
                              "properties": {
                                "10a_other": {
                                  "enum": [true]
                                },
                                "10a_note_other": {"title": "For comments", "type": "string"}
                              },
                              "required": []
                            },
                            {
                              "properties": {
                                "10a_other": {
                                  "enum": [false]
                                }
                              },
                              "required": []
                            }
                          ]
                        }
                      },
                      "required": []
                    },
                    "11a": {
                      "title":
                          "11a. Were authorized persons present at the opening of this polling stations? Did you see:",
                      "type": "object",
                      "properties": {
                        "11a_partisan_observers": {
                          "title": "Partisan observers",
                          "type": "boolean"
                        },
                        "11a_nonpartisan_groups": {
                          "title": "Nonpartisan groups",
                          "type": "boolean"
                        },
                        "11a_international_observers": {
                          "title": "International observers (apart from SILBA)",
                          "type": "boolean"
                        },
                        "11a_journalists": {"title": "Journalists", "type": "boolean"},
                        "11a_it_support": {"title": "IT Support", "type": "boolean"},
                        "11a_other": {"title": "Other (comment below)", "type": "boolean"}
                      },
                      "dependencies": {
                        "11a_other": {
                          "oneOf": [
                            {
                              "properties": {
                                "11a_other": {
                                  "enum": [true]
                                },
                                "11a_other_note": {"title": "For comments", "type": "string"}
                              },
                              "required": []
                            },
                            {
                              "properties": {
                                "11a_other": {
                                  "enum": [false]
                                }
                              },
                              "required": []
                            }
                          ]
                        }
                      },
                      "required": []
                    },
                    "transparency": {
                      "title": "Transparency",
                      "type": "object",
                      "properties": {
                        "12a": {
                          "enum": ["yes", "no", "not_applicable"],
                          "title":
                              "12a. Did observers present have a clear view of the opening procedures?",
                          "type": "string",
                          "enumNames": ["yes", "no", "not applicable"]
                        },
                        "13a": {
                          "enum": ["yes", "no", "not_applicable"],
                          "title":
                              "13a. Were you in any way restricted in your observation of the opening procedures?",
                          "type": "string",
                          "enumNames": ["yes", "no", "not applicable"]
                        },
                        "14a": {
                          "enum": ["yes", "no", "not_applicable"],
                          "title":
                              "14a. Did any authorized observers inform you of problems at this polling station during opening?",
                          "type": "string",
                          "enumNames": ["yes", "no", "not applicable"]
                        }
                      },
                      "dependencies": {
                        "12a": {
                          "oneOf": [
                            {
                              "properties": {
                                "12a": {
                                  "enum": ["no"]
                                },
                                "12a_why": {
                                  "title": "Please write an explanation why.",
                                  "type": "string"
                                }
                              },
                              "required": []
                            },
                            {
                              "properties": {
                                "12a": {
                                  "enum": ["yes", "not_applicable"]
                                }
                              },
                              "required": []
                            }
                          ]
                        },
                        "13a": {
                          "oneOf": [
                            {
                              "properties": {
                                "13a": {
                                  "enum": ["yes"]
                                },
                                "13a_note": {
                                  "title": "Describe how you were restrictred",
                                  "type": "string"
                                }
                              },
                              "required": []
                            },
                            {
                              "properties": {
                                "13a": {
                                  "enum": ["no", "not_applicable"]
                                }
                              },
                              "required": []
                            }
                          ]
                        },
                        "14a": {
                          "oneOf": [
                            {
                              "properties": {
                                "14a": {
                                  "enum": ["yes"]
                                },
                                "14a_why": {"title": "What were these problems?", "type": "string"}
                              },
                              "required": []
                            },
                            {
                              "properties": {
                                "14a": {
                                  "enum": ["no", "not_applicable"]
                                }
                              },
                              "required": []
                            }
                          ]
                        }
                      },
                      "required": ["12a", "13a", "14a"]
                    },
                    "15a": {
                      "enum": ["yes", "no"],
                      "title":
                          "15a. Are female international and citizen election observers able to observe all aspects of the electoral process?",
                      "type": "string",
                      "enumNames": ["yes", "no"]
                    },
                    "extra_notes": {
                      "enum": ["yes", "no"],
                      "title":
                          "Have you noticed anything that this questionnaire does not include?",
                      "type": "string",
                      "enumNames": ["yes", "no"]
                    },
                    "group_number": {"title": "Group number", "type": "string"},
                    "ps_id": {"title": "Polling Station ID", "type": "string"},
                    "number_of_pso": {"title": "No. of appointed PSOs", "type": "integer"},
                    "overall_rating": {
                      "enum": ["1", "2", "3", "4"],
                      "title": "Overall rating",
                      "type": "string",
                      "enumNames": ["1", "2", "3", "4"]
                    },
                    "ps_number": {"title": "Polling station no. out of", "type": "string"},
                    "time_of_arrival": {
                      "format": "date-time",
                      "title": "Time of arrival",
                      "type": "string"
                    },
                    "time_of_departure": {
                      "format": "date-time",
                      "title": "Time of departure",
                      "type": "string"
                    },
                    "chairperson_gender": {
                      "enum": ["male", "female"],
                      "title": "Choose polling station chairperson's gender",
                      "type": "string",
                      "enumNames": ["male", "female"]
                    }
                  },
                  "required": [
                    "name",
                    "phone_number_signal",
                    "phone_number_poland",
                    "observation_spot",
                    "2a",
                    "3a",
                    "4a",
                    "5a",
                    "6a",
                    "7a",
                    "8a",
                    "9a",
                    "15a",
                    "extra_notes",
                    "group_number",
                    "ps_id",
                    "number_of_pso",
                    "overall_rating",
                    "ps_number",
                    "time_of_arrival",
                    "time_of_departure",
                    "chairperson_gender"
                  ],
                  "dependencies": {
                    "2a": {
                      "oneOf": [
                        {
                          "properties": {
                            "2a": {
                              "enum": ["no"]
                            },
                            "2a_why": {"title": "Please write an explanation why.", "type": "string"}
                          },
                          "required": []
                        },
                        {
                          "properties": {
                            "2a": {
                              "enum": ["yes", "not_applicable"]
                            }
                          },
                          "required": []
                        }
                      ]
                    },
                    "3a": {
                      "oneOf": [
                        {
                          "properties": {
                            "3a": {
                              "enum": ["no"]
                            },
                            "3a_why": {"title": "Please write an explanation why.", "type": "string"}
                          },
                          "required": []
                        },
                        {
                          "properties": {
                            "3a": {
                              "enum": ["yes", "not_applicable"]
                            }
                          },
                          "required": []
                        }
                      ]
                    },
                    "4a": {
                      "oneOf": [
                        {
                          "properties": {
                            "4a": {
                              "enum": ["no"]
                            },
                            "4a_why": {
                              "title": "Please write an explanation why. What were they like?",
                              "type": "string"
                            },
                            "4a_file": {
                              "title": "Attach photo of packages and envelopes.",
                              "type": "string"
                            }
                          },
                          "required": []
                        },
                        {
                          "properties": {
                            "4a": {
                              "enum": ["yes", "not_applicable"]
                            }
                          },
                          "required": []
                        }
                      ]
                    },
                    "5a": {
                      "oneOf": [
                        {
                          "properties": {
                            "5a": {
                              "enum": ["no"]
                            },
                            "5a_why": {"title": "Please write an explanation why.", "type": "string"}
                          },
                          "required": []
                        },
                        {
                          "properties": {
                            "5a": {
                              "enum": ["yes", "not_applicable"]
                            }
                          },
                          "required": []
                        }
                      ]
                    },
                    "6a": {
                      "oneOf": [
                        {
                          "properties": {
                            "6a": {
                              "enum": ["no"]
                            },
                            "6a_why": {"title": "Please write an explanation why.", "type": "string"},
                            "6a_file": {"title": "Attach photos of the ballot boxes", "type": "string"}
                          },
                          "required": []
                        },
                        {
                          "properties": {
                            "6a": {
                              "enum": ["yes", "not_applicable"]
                            }
                          },
                          "required": []
                        }
                      ]
                    },
                    "7a": {
                      "oneOf": [
                        {
                          "properties": {
                            "7a": {
                              "enum": ["no"]
                            },
                            "7a_why": {"title": "Please write an explanation why.", "type": "string"}
                          },
                          "required": []
                        },
                        {
                          "properties": {
                            "7a": {
                              "enum": ["yes", "not_applicable"]
                            }
                          },
                          "required": []
                        }
                      ]
                    },
                    "8a": {
                      "oneOf": [
                        {
                          "properties": {
                            "8a": {
                              "enum": ["no"]
                            },
                            "8a_why": {"title": "Please write an explanation why.", "type": "string"}
                          },
                          "required": []
                        },
                        {
                          "properties": {
                            "8a": {
                              "enum": ["yes", "not_applicable"]
                            }
                          },
                          "required": []
                        }
                      ]
                    },
                    "9a": {
                      "oneOf": [
                        {
                          "properties": {
                            "9a": {
                              "enum": ["no"]
                            },
                            "9a_why": {"title": "Please write an explanation why.", "type": "string"},
                            "9a_time": {
                              "format": "date-time",
                              "title": "When did the PS open?",
                              "type": "string",
                              "default": "2022-10-02T07:00"
                            }
                          },
                          "required": []
                        },
                        {
                          "properties": {
                            "9a": {
                              "enum": ["yes", "not_applicable"]
                            }
                          },
                          "required": []
                        }
                      ]
                    },
                    "extra_notes": {
                      "oneOf": [
                        {
                          "properties": {
                            "extra_notes": {
                              "enum": ["yes"]
                            },
                            "place_for_extra_notes": {
                              "title": "Write below the things that you noticed:",
                              "type": "string"
                            },
                            "extra_notes_file": {"title": "Attach files if needed", "type": "string"}
                          },
                          "required": ["place_for_extra_notes"]
                        },
                        {
                          "properties": {
                            "extra_notes": {
                              "enum": ["no"]
                            }
                          },
                          "required": []
                        }
                      ]
                    }
                  }
                }
              ]
            }
          },
          "required": ["back_to_observer"],
          "title": "Opening Procedures Verification"
        }, uiSchema: {
          "back_to_observer": {"ui:widget": "radio"},
          "note": {"ui:widget": "textarea"},
          "1a": {
            "1a_note": {"ui:widget": "textarea"},
            "1a_files": {
              "ui:widget": "customfile",
              "ui:options": {"private": false, "multiple": true}
            },
            "ui:order": [
              "1a_polling_booth",
              "1a_ballot_papers",
              "1a_voters_list",
              "1a_protocols",
              "1a_ballot_box_seals",
              "1a_ballot_box",
              "1a_stamps",
              "1a_data_protection_sheet",
              "1a_other",
              "1a_note",
              "1a_files"
            ]
          },
          "2a": {"ui:widget": "radio"},
          "2a_why": {"ui:widget": "textarea"},
          "3a": {"ui:widget": "radio"},
          "3a_why": {"ui:widget": "textarea"},
          "4a": {"ui:widget": "radio"},
          "4a_why": {"ui:widget": "textarea"},
          "4a_file": {
            "ui:widget": "customfile",
            "ui:options": {"private": false, "multiple": true}
          },
          "5a": {"ui:widget": "radio"},
          "5a_why": {"ui:widget": "textarea"},
          "6a": {"ui:widget": "radio"},
          "6a_why": {"ui:widget": "textarea"},
          "6a_file": {
            "ui:widget": "customfile",
            "ui:options": {"private": false, "multiple": true}
          },
          "7a": {"ui:widget": "radio"},
          "7a_why": {"ui:widget": "textarea"},
          "8a": {"ui:widget": "radio"},
          "8a_why": {"ui:widget": "textarea"},
          "9a": {"ui:widget": "radio"},
          "9a_why": {"ui:widget": "textarea"},
          "10a": {
            "10a_note_other": {"ui:widget": "textarea"},
            "ui:order": [
              "10a_uninvited_police",
              "10a_police_why",
              "10a_local_officials",
              "10a_which_local_officials",
              "10a_state_officials",
              "10a_which_state_officials",
              "10a_military",
              "10a_military_why",
              "10a_candidate",
              "10a_which_candidate",
              "10a_party_activist",
              "10a_which_party_activist",
              "10a_other",
              "10a_note_other"
            ]
          },
          "10a_file": {
            "ui:widget": "customfile",
            "ui:options": {"private": false, "multiple": true}
          },
          "11a": {
            "11a_other_note": {"ui:widget": "textarea"},
            "ui:order": [
              "11a_partisan_observers",
              "11a_nonpartisan_groups",
              "11a_international_observers",
              "11a_journalists",
              "11a_it_support",
              "11a_other",
              "11a_other_note"
            ]
          },
          "11_a_file": {
            "ui:widget": "customfile",
            "ui:options": {"private": false, "multiple": true}
          },
          "transparency": {
            "12a": {"ui:widget": "radio"},
            "12a_why": {"ui:widget": "textarea"},
            "13a": {"ui:widget": "radio"},
            "13a_note": {"ui:widget": "textarea"},
            "14a": {"ui:widget": "radio"},
            "14a_why": {"ui:widget": "textarea"},
            "ui:order": ["12a", "12a_why", "13a", "13a_note", "14a", "14a_why"]
          },
          "15a": {"ui:widget": "radio"},
          "extra_notes": {"ui:widget": "radio"},
          "place_for_extra_notes": {"ui:widget": "textarea"},
          "extra_notes_file": {
            "ui:widget": "customfile",
            "ui:options": {"private": false, "multiple": true}
          },
          "overall_rating": {"ui:widget": "radio"},
          "chairperson_gender": {"ui:widget": "radio"},
          "ui:order": [
            "back_to_observer",
            "note",
            "name",
            "phone_number_signal",
            "phone_number_poland",
            "observation_spot",
            "1a",
            "2a",
            "2a_why",
            "3a",
            "3a_why",
            "4a",
            "4a_why",
            "4a_file",
            "5a",
            "5a_why",
            "6a",
            "6a_why",
            "6a_file",
            "7a",
            "7a_why",
            "8a",
            "8a_why",
            "9a",
            "9a_why",
            "9a_time",
            "10a",
            "10a_file",
            "11a",
            "11_a_file",
            "transparency",
            "15a",
            "extra_notes",
            "place_for_extra_notes",
            "extra_notes_file",
            "group_number",
            "ps_id",
            "number_of_pso",
            "overall_rating",
            "ps_number",
            "time_of_arrival",
            "time_of_departure",
            "chairperson_gender"
          ]
        }, formData: {
          "1a": {"1a_ballot_papers": true, "1a_polling_booth": true},
          "2a": "yes",
          "3a": "no",
          "4a": "not_applicable",
          "5a": "not_applicable",
          "6a": "not_applicable",
          "7a": "yes",
          "8a": "no",
          "9a": "yes",
          "10a": {
            "10a_military": true,
            "10a_military_why": "kj",
            "10a_local_officials": false,
            "10a_uninvited_police": false
          },
          "11a": {"11a_international_observers": true},
          "15a": "yes",
          "name": "dfsljngr",
          "ps_id": "5",
          "3a_why": "kj",
          "8a_why": "kmjn ",
          "10a_file":
              "{\"Screenshot 2023-10-10 at 12.02.03.png\":\"public/41/196/2940/M1eBXDyMPIeqUGUkbQF9DsmDpT03/471965/Screenshot 2023-10-10 at 12.02.03.png\"}",
          "ps_number": "1",
          "extra_notes": "no",
          "group_number": "5",
          "transparency": {"12a": "yes", "13a": "not_applicable", "14a": "no"},
          "number_of_pso": 5,
          "overall_rating": "2",
          "time_of_arrival": "11-10-2023 18:00",
          "observation_spot": "erg",
          "time_of_departure": "27-10-2023 12:00",
          "chairperson_gender": "female",
          "phone_number_poland": "54",
          "phone_number_signal": "45"
        });
}
