defmodule Sparkpost.Transmission.Options do
  defstruct start_time: nil,
    open_tracking: true,
    click_tracking: true,
    transactional: nil,
    sandbox: nil,
    skip_suppression: nil
end

defmodule Sparkpost.Transmission do
  @moduledoc """
  The SparkPost Transmission API endpoint for sending email. Use ```Sparkpost.Transmission.create/1``` to
  send messages, Sparkpost.Transmission.list/1 to list previous sends and Sparkpost.Transmission.get/1 to
  retrieve details on a given transmission.

  Check out the documentation for each function
  or use the [Sparkpost API reference](https://www.sparkpost.com/api#/reference/transmissions) for details.
  """
  defstruct options: :required,
    campaign_id: nil,
    return_path: :required,
    metadata: nil,
    substitution_data: nil,
    recipients: :required,
    content: :required,
    id: nil,     # System generated fields from this point on
    description: nil,
    state: nil,
    rcpt_list_chunk_size: nil,
    rcp_list_total_chunks: nil,
    num_rcpts: nil,
    num_generated: nil,
    num_failed_gen: nil,
    generation_start_time: nil,
    generation_end_time: nil

  defmodule Response do
    defstruct id: nil,
      total_accepted_recipients: nil,
      total_rejected_recipients: nil
  end

  @doc """
  Create a new transmission and send some email.

  ## Parameters
  - %Sparkpost.Transmission.Request{} consisting of:
    - recipients: [%Sparkpost.Recipient{}] or %SparkPost.Recipient.ListRef{}
    - content: %Sparkpost.Template.Inline{}, %Sparkpost.Template.Raw{} or %Sparkpost.Template.Ref{}
    - options: %Sparkpost.Transmission.Options{}
    - campaign_id: campaign identifier (string)
    - return_path: envelope FROM address (email address string)
    - metadata: transmission-level metadata k/v pairs (keyword)
    - substitution_data: transmission-level substitution_data k/v pairs (keyword)

  ## Examples
  Send a message to a single recipient with inline text and HTML content:

      Sparkpost.Transmission.create(%Sparkpost.Transmission.Request{
        options: %Sparkpost.Transmission.Options{},
        recipients: [ %Sparkpost.Recipient{ address: %Sparkpost.Address{ email: "to@you.com" }} ],
        return_path: "from@me.com",
        content: %Sparkpost.Template.Inline{
          subject: subject,
          from: %Sparkpost.Address{ email: "from@me.com" },
          text: text,
          html: html
        }
      })
      #=> Sparkpost.Transmission.Response{id: "102258889940193104", total_accepted_recipients: 1, total_rejected_recipients: 0}

  Send a message to 2 recipients using a stored message template:
      Sparkpost.Transmission.create(
        %Sparkpost.Transmission.Request{
          options: %Sparkpost.Transmission.Options{},
          recipients: Sparkpost.Recipient.to_recipient_list["to@you.com", "to@youtoo.com"],
          return_path: "from@me.com",
          content: %Sparkpost.Template.Ref{ template_id: "test-template-1" }
        }
      )
      #=> Sparkpost.Transmission.Response{id: "102258889940193105", total_accepted_recipients: 2, total_rejected_recipients: 0}
  """
  def create(%__MODULE__{} = body) do
    response = Sparkpost.Endpoint.request(:post, "transmissions", [body: body])
    Sparkpost.Endpoint.marshal_response(response, Sparkpost.Transmission.Response)
  end

  @doc """
  Retrieve the details of an existing transmission.

  ## Parameters
   - transmission ID: identifier of the transmission to retrieve

  ## Example

      Sparkpost.Transmission.get("102258889940193105")
      #=> %Sparkpost.Transmission{campaign_id: "",
             content: %{template_id: "inline", template_version: 0,
               use_draft_template: false}, description: "",
             generation_end_time: "2016-01-14T12:52:05+00:00",
             generation_start_time: "2016-01-14T12:52:05+00:00", id: "48215348926834924",
             metadata: "", num_failed_gen: 0, num_generated: 2, num_rcpts: 2,
             options: %{click_tracking: true, conversion_tracking: "", open_tracking: true},
             rcp_list_total_chunks: nil, rcpt_list_chunk_size: 100, recipients: :required,
             return_path: "ewan.dennis@cloudygoo.com", state: "Success",
             substitution_data: ""}
  """
  def get(transid) do
    response = Sparkpost.Endpoint.request(:get, "transmissions/" <> transid, [])
    Sparkpost.Endpoint.marshal_response(response, __MODULE__, :transmission)
  end

  @doc """
  List all multi-recipient transmissions, possibly filtered by campaign_id and/or template.

  ## Parameters
  - query filters to narrow the list (keyword)
    - campaign_id
    - template_id

  ## Example
  List all multi-recipient transmissions:
      Sparkpost.Transmission.list()
      #=> [%Sparkpost.Transmission{campaign_id: "", content: %{template_id: "inline"},
        description: "", generation_end_time: nil, generation_start_time: nil,
        id: "102258558346809186", metadata: nil, num_failed_gen: nil,
        num_generated: nil, num_rcpts: nil, options: :required,
        rcp_list_total_chunks: nil, rcpt_list_chunk_size: nil, recipients: :required,
        return_path: :required, state: "Success", substitution_data: nil},
       %Sparkpost.Transmission{campaign_id: "", content: %{template_id: "inline"},
        description: "", generation_end_time: nil, generation_start_time: nil,
        id: "48215348926834924", metadata: nil, num_failed_gen: nil,
        num_generated: nil, num_rcpts: nil, options: :required,
        rcp_list_total_chunks: nil, rcpt_list_chunk_size: nil, recipients: :required,
        return_path: :required, state: "Success", substitution_data: nil}]
  """
  def list(filters\\[]) do
    response = Sparkpost.Endpoint.request(:get, "transmissions", [params: filters])
    case response do
      %Sparkpost.Endpoint.Response{} ->
        Enum.map(response.results, fn (trans) -> struct(__MODULE__, trans) end)
      true -> response
    end
  end
end