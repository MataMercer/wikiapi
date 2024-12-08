"use client";
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
} from "@/components/ui/dialog";
import { Controller, SubmitHandler, useForm } from "react-hook-form";
import { refreshArticles } from "./actions";
import MDEditor from "@uiw/react-md-editor";
import { useEffect, useState } from "react";
import React from "react";
import UploadInput, { FileInput } from "./components/inputs/UploadInput";
import useTimelines from "./hooks/useTimelines";
import useCurrentUser from "./hooks/useCurrentUser";
import useCharacters from "./hooks/useCharacters";

type Inputs = {
    name: string;
    gender: string;
    age: number;
    birthday: string;
    firstSeen: string;
    status: string;

    body: string;
    attachments: string[];
    uploadedAttachments: FileInput[];
};

export default function CreateCharacterButton() {
    const {
        register,
        handleSubmit,
        watch,
        setValue,
        reset,
        formState: { errors },
        control,
    } = useForm<Inputs>({
        defaultValues: {
            name: "ExampleName",
            body: "ExampleBody",
            attachments: [],
            uploadedAttachments: [],
        },
    });

    const {
        user,
        loading,
        loggedOut,
        mutate: mutateCurrentUser,
    } = useCurrentUser();
    const userId = user && user.id;

    const [showArticleForm, setShowCharacterForm] = useState(false);
    const ref = React.useRef();
    const onSubmit: SubmitHandler<Inputs> = async (data) => {
        const formData = new FormData();
        formData.append("name", data.name);
        formData.append("gender", data.gender);
        formData.append("age", data.age.toString());
        formData.append("birthday", data.birthday);
        formData.append("firstSeen", data.firstSeen);
        formData.append("status", data.status);
        formData.append("body", data.body);

        data.uploadedAttachments
            .filter((it) => it.data)
            .map((it) => {
                it.data && formData.append("uploadedAttachments", it.data);
            });

        const response = await fetch("http://localhost:7070/api/characters", {
            method: "POST",
            credentials: "include",
            body: formData,
        });

        if (response.ok) {
            refreshArticles();
            ref.current?.click();
            reset();
        } else {
        }
    };

    return (
        <Dialog>
            <DialogTrigger asChild ref={ref}>
                <button
                    className="button"
                    onClick={() => {
                        setShowCharacterForm(true);
                    }}
                >
                    CREATE CHARACTER
                </button>
            </DialogTrigger>
            <DialogContent className="sm:max-w-[90vw]">
                <form onSubmit={handleSubmit(onSubmit)}>
                    <DialogHeader>
                        <DialogTitle>CREATE CHARACTER</DialogTitle>
                    </DialogHeader>
                    <div className="flex flex-col gap-4 py-4">
                        <label className="flex flex-col" htmlFor="name">
                            Name
                            <input
                                {...register("name", { required: true })}
                                id="name"
                                defaultValue="Unnamed"
                            />
                        </label>
                        <label className="flex flex-col" htmlFor="gender">
                            Gender
                            <input
                                {...register("gender", { required: true })}
                                id="gender"
                                defaultValue="Male"
                            />
                        </label>
                        <label className="flex flex-col" htmlFor="age">
                            Age
                            <input
                                {...register("age", {
                                    min: 1,
                                    max: 30000,
                                    required: true,
                                })}
                                id="age"
                                defaultValue="18"
                                type="number"
                            />
                        </label>
                        <label className="flex flex-col" htmlFor="birthday">
                            Birthday
                            <input
                                {...register("birthday", { required: true })}
                                id="birthday"
                                defaultValue="Jan 1, 1990"
                            />
                        </label>
                        <label className="flex flex-col" htmlFor="firstSeen">
                            First Seen
                            <input
                                {...register("firstSeen", { required: true })}
                                id="firstSeen"
                                defaultValue="Episode 1"
                            />
                        </label>
                        <label className="flex flex-col" htmlFor="Status">
                            Status
                            <input
                                {...register("status", { required: true })}
                                id="Status"
                                defaultValue="Alive"
                            />
                        </label>

                        <label className="flex flex-col" htmlFor="body">
                            Body
                            {/* <textarea
                                    {...register("body", { required: true })}
                                    id="body"
                                    defaultValue="Empty body"
                                    rows={20}
                                /> */}
                            <Controller
                                name="body"
                                control={control}
                                defaultValue="Empty body"
                                render={({ field }) => (
                                    <div data-color-mode="light">
                                        <MDEditor
                                            value={field.value}
                                            onChange={field.onChange}
                                        />
                                    </div>
                                )}
                            />
                        </label>

                        <label className="flex flex-col" htmlFor="">
                            File Attachments
                            <Controller
                                name="uploadedAttachments"
                                control={control}
                                render={({ field }) => (
                                    <UploadInput
                                        id="uploadedAttachments"
                                        setFileInputs={(files: FileInput[]) => {
                                            setValue(
                                                "uploadedAttachments",
                                                files
                                            );
                                        }}
                                        fileInputs={field.value}
                                    />
                                )}
                            ></Controller>
                        </label>
                    </div>
                    <DialogFooter>
                        <button className="button" type="submit">
                            Submit
                        </button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    );
}