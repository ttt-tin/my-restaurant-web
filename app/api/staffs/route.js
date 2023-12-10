import excuteQuery from "../lib/connectDb";

export const GET = async (req) => {
    try {
        const result = await excuteQuery({
            query: "SELECT * FROM staff",
        })
        return new Response(JSON.stringify(result), {status: 200})
    } catch (error) {
        return new Response("Something wrong in server", {status: 500})
    }
}

export const POST = async (req) => {
    try {
        const {Staff_name, Staff_address, Sphone, Sex, Area_name} = await req.json();
        await excuteQuery({
            query: "CALL sp_InsertStaff(?, ?, ?, ?, ?)",
            values: [Staff_name, Staff_address, Sphone, Sex, Area_name]
        })
        return new Response(JSON.stringify({"msg": "Success"}), {status: 200})
    } catch (error) {
        return new Response(JSON.stringify({error: error}), {status: 500})
    }
}

export const DELETE = async (req) => {
    try {
        const {Staff_ID} = await req.json();
        await excuteQuery({
            query: "CALL sp_DeleteStaff(?)",
            values: [Staff_ID]
        })
        return new Response(JSON.stringify({"msg": "Success"}), {status: 200})
    } catch (error) {
        return new Response(JSON.stringify({error: error}), {status: 500})
    }
}