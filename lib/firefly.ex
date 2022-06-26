defmodule Firefly do
  @moduledoc """
  This module contains helpers related to firefly as an event as a whole, rather than any events taking place within it
  """

  @start_date Application.fetch_env!(:what_where_when, :firefly_start_date)
  @end_date Application.fetch_env!(:what_where_when, :firefly_end_date)

  @date_range Date.range(@start_date, @end_date)

  def start_date, do: @start_date
  def end_date, do: @end_date

  def date_range, do: @date_range
end
