"use client";
import { DataGrid } from "@mui/x-data-grid";

const Table = ({rows, setRows, columns, rowModesModel, setRowModesModel, handleRowModesModelChange, handleRowEditStop, processRowUpdate, EditToolbar, idField}) => {
  return (
    <DataGrid
      rows={rows}
      columns={columns}
      editMode="row"
      rowModesModel={rowModesModel}
      onRowModesModelChange={handleRowModesModelChange}
      onRowEditStop={handleRowEditStop}
      processRowUpdate={processRowUpdate}
      slots={{
        toolbar: EditToolbar,
      }}
      slotProps={{
        toolbar: { setRows, setRowModesModel },
      }}
      getRowId={(row) => row[idField]}
    />
  );
};

export default Table;
