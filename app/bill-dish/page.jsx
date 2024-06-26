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
  const { rows, setRows, setRowModesModel } = props;

  const handleClick = () => {
    const id = rows.length;
    setRows((oldRows) => {
      return [
        ...oldRows,
        { id: id, Bill_ID: "", Dish_ID: "", Amount: 0, isNew: true },
      ];
    });
    setRowModesModel((oldModel) => ({
      ...oldModel,
      [id]: { mode: GridRowModes.Edit, fieldToFocus: "Bill_ID" },
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

const addNewBillDish = async (row) => {
  try {
    console.log(row);
    const res = await fetch(`api/bill-dish`, {
      method: "POST",
      body: JSON.stringify({
        bill_ID: row.Bill_ID,
        dish_ID: row.Dish_ID,
        amount: row.Amount
      }),
    });
  } catch (error) {
    console.log(error);
  }
};

const deleteBillDish = async (bill_ID, dish_ID) => {
  try {
    const res = await fetch(`api/bill-dish`, {
      method: "DELETE",
      body: JSON.stringify({
        bill_ID: bill_ID,
        dish_ID: dish_ID
      }),
    });
  } catch (error) {
    console.log(error);
  }
};

export default function BillDishPage() {
  const [rows, setRows] = React.useState([]);
  const [rowModesModel, setRowModesModel] = React.useState({});
  const [loading, setLoading] = React.useState(true);

  React.useEffect(() => {
    const fetchStaffs = async () => {
      const res = await fetch(`api/bill-dish`);
      let data = await res.json();
      data = data.map((row, index) => {
        return { ...row, id: index };
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
    const bill_ID = rows[id].Bill_ID
    const dish_ID = rows[id].Dish_ID
    deleteBillDish(bill_ID, dish_ID);
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
    addNewBillDish(newRow);
    const updatedRow = { ...newRow, isNew: false };
    setRows(rows.map((row) => (row.id === newRow.id ? updatedRow : row)));
    return updatedRow;
  };

  const handleRowModesModelChange = (newRowModesModel) => {
    setRowModesModel(newRowModesModel);
  };

  const columns = [
    {
      field: "Bill_ID",
      headerName: "Bill ID",
      type: "string",
      width: 80,
      align: "left",
      headerAlign: "left",
      editable: true,
    },
    {
      field: "Dish_ID",
      headerName: "Dish ID",
      type: "string",
      width: 80,
      editable: true,
    },
    {
      field: "Amount",
      headerName: "Amount",
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
          rowModesModel[row.id]?.mode === GridRowModes.Edit;

        if (isInEditMode) {
          return [
            <GridActionsCellItem
              icon={<SaveIcon />}
              label="Save"
              sx={{
                color: "primary.main",
              }}
              onClick={handleSaveClick(row.id)}
            />,
            <GridActionsCellItem
              icon={<CancelIcon />}
              label="Cancel"
              className="textPrimary"
              onClick={handleCancelClick(row.id)}
              color="inherit"
            />,
          ];
        }

        return [
          <GridActionsCellItem
            icon={<EditIcon />}
            label="Edit"
            className="textPrimary"
            onClick={handleEditClick(row.id)}
            color="inherit"
          />,
          <GridActionsCellItem
            icon={<DeleteIcon />}
            label="Delete"
            onClick={handleDeleteClick(row.id)}
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
        Quản lí món ăn phục vụ
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
            toolbar: { rows, setRows, setRowModesModel },
          }}
          getRowId={(row) => row.id}
        />
      )}
    </Box>
  );
}
