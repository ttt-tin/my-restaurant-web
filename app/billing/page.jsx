"use client";
import * as React from "react";
import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import AddIcon from "@mui/icons-material/Add";
import EditIcon from "@mui/icons-material/Edit";
import DeleteIcon from "@mui/icons-material/DeleteOutlined";
import SaveIcon from "@mui/icons-material/Save";
import CancelIcon from "@mui/icons-material/Close";
import {
  GridRowModes,
  DataGrid,
  GridToolbarContainer,
  GridActionsCellItem,
  GridRowEditStopReasons,
} from "@mui/x-data-grid";
import {
  randomCreatedDate,
  randomTraderName,
  randomId,
  randomArrayItem,
} from "@mui/x-data-grid-generator";
import { CircularProgress, Typography } from "@mui/material";

function EditToolbar(props) {
  const { setRows, setRowModesModel } = props;
  const currentDateTime = new Date();

  const formattedDateTime = currentDateTime
    .toISOString()
    .slice(0, 19)
    .replace("T", " ");
  const handleClick = () => {
    let newId = 0;
    setRows((oldRows) => {
      newId = oldRows.length + 1;
      return [
        ...oldRows,
        {
          Bill_ID: oldRows.length + 1,
          Start_time: formattedDateTime,
          End_time: formattedDateTime,
          Num_of_people: "",
          Total_discount: 0,
          Total_payment: 0,
          Staff_ID: "",
          isNew: true,
        },
      ];
    });
    setRowModesModel((oldModel) => ({
      ...oldModel,
      [newId]: { mode: GridRowModes.Edit, fieldToFocus: "Staff_name" },
    }));
  };

  return (
    <GridToolbarContainer>
      <Button color="primary" startIcon={<AddIcon />} onClick={handleClick}>
        Add record
      </Button>
    </GridToolbarContainer>
  );
}

const addNewBill = async (row) => {
  try {
    const res = await fetch(`api/billing`, {
      method: "POST",
      body: JSON.stringify({
        Bill_ID: row.Bill_ID,
        Start_time: row.Start_time,
        End_time: row.End_time,
        Num_of_people: row.Num_of_people,
        Total_discount: row.Total_discount,
        Total_payment: row.Total_payment,
        Staff_ID: row.Staff_ID,
      }),
    });
  } catch (error) {
    console.log(error);
  }
};

const deleteBill = async (id) => {
  try {
    const res = await fetch(`api/billing`, {
      method: "DELETE",
      body: JSON.stringify({
        Bill_ID: id,
      }),
    });
  } catch (error) {
    console.log(error);
  }
};

export default function BillingPage() {
  const [rows, setRows] = React.useState([]);
  const [rowModesModel, setRowModesModel] = React.useState({});
  const [loading, setLoading] = React.useState(true);

  React.useEffect(() => {
    const fetchStaffs = async () => {
      const res = await fetch(`api/billing`);
      let data = await res.json();
      data = data.map((row) => {
        return {
          ...row,
          Start_time: row.Start_time.slice(0, 19).replace("T", " "),
          End_time: row.End_time.slice(0, 19).replace("T", " "),
        };
      });

      setRows(data);
      setLoading(false);
    };

    fetchStaffs();
  }, []);

  const handleRowEditStop = (params, event) => {
    if (params.reason === GridRowEditStopReasons.rowFocusOut) {
      event.defaultMuiPrevented = true;
    }
  };

  const handleEditClick = (id) => () => {
    setRowModesModel({ ...rowModesModel, [id]: { mode: GridRowModes.Edit } });
  };

  const handleSaveClick = (id) => () => {
    setRowModesModel({ ...rowModesModel, [id]: { mode: GridRowModes.View } });
  };

  const handleDeleteClick = (id) => () => {
    deleteBill(id);
    setRows(rows.filter((row) => row.id !== id));
  };

  const handleCancelClick = (id) => () => {
    setRowModesModel({
      ...rowModesModel,
      [id]: { mode: GridRowModes.View, ignoreModifications: true },
    });

    const editedRow = rows.find((row) => row.id === id);
    if (editedRow.isNew) {
      setRows(rows.filter((row) => row.id !== id));
    }
  };

  const processRowUpdate = (newRow) => {
    if (rows.length === newRow.Bill_ID) {
      addNewBill(newRow);
    }
    const updatedRow = { ...newRow, isNew: false };
    setRows(
      rows.map((row) => (row.Bill_ID === newRow.Bill_ID ? updatedRow : row))
    );
    return updatedRow;
  };

  const handleRowModesModelChange = (newRowModesModel) => {
    setRowModesModel(newRowModesModel);
  };

  const columns = [
    {
      field: "Bill_ID",
      headerName: "ID",
      type: "string",
      width: 80,
      align: "left",
      headerAlign: "left",
      editable: true,
    },
    {
      field: "Start_time",
      headerName: "Start time",
      type: "string",
      width: 200,
      editable: true,
    },
    {
      field: "End_time",
      headerName: "End time",
      type: "string",
      width: 200,
      align: "left",
      headerAlign: "left",
      editable: true,
    },
    {
      field: "Num_of_people",
      headerName: "People",
      type: "number",
      width: 80,
      align: "left",
      headerAlign: "left",
      editable: true,
    },
    {
      field: "Total_discount",
      headerName: "Total discount",
      type: "number",
      width: 150,
      align: "left",
      headerAlign: "left",
      editable: true,
    },
    {
      field: "Total_payment",
      headerName: "Total payment",
      type: "number",
      width: 150,
      align: "left",
      headerAlign: "left",
      editable: true,
    },
    {
      field: "Staff_ID",
      headerName: "Manager ID",
      type: "number",
      width: 100,
      align: "left",
      headerAlign: "left",
      editable: true,
    },
    {
      field: "actions",
      type: "actions",
      headerName: "Actions",
      width: 100,
      cellClassName: "actions",
      getActions: ({ row }) => {
        const isInEditMode =
          rowModesModel[row.Bill_ID]?.mode === GridRowModes.Edit;

        if (isInEditMode) {
          return [
            <GridActionsCellItem
              icon={<SaveIcon />}
              label="Save"
              sx={{
                color: "primary.main",
              }}
              onClick={handleSaveClick(row.Bill_ID)}
            />,
            <GridActionsCellItem
              icon={<CancelIcon />}
              label="Cancel"
              className="textPrimary"
              onClick={handleCancelClick(row.Bill_ID)}
              color="inherit"
            />,
          ];
        }

        return [
          <GridActionsCellItem
            icon={<EditIcon />}
            label="Edit"
            className="textPrimary"
            onClick={handleEditClick(row.Bill_ID)}
            color="inherit"
          />,
          <GridActionsCellItem
            icon={<DeleteIcon />}
            label="Delete"
            onClick={handleDeleteClick(row.Bill_ID)}
            color="inherit"
          />,
        ];
      },
    },
  ];

  return (
    <Box
      className="mt-20 mx-2"
      sx={{
        height: 500,
        width: "100%",
        "& .actions": {
          color: "text.secondary",
        },
        "& .textPrimary": {
          color: "text.primary",
        },
      }}
    >
      <Typography variant="h5" color="text.primary" align="left" my={2}>
        Quản lí hóa đơn
      </Typography>
      {loading ? (
        <CircularProgress />
      ) : (
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
          getRowId={(row) => row.Bill_ID}
        />
      )}
    </Box>
  );
}
