package apperrors

import (
	stderrors "errors"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/protoadapt"
)

type ErrorST struct {
	st      *status.Status
	content string
}

func (e ErrorST) Error() string {
	if e.content != "" {
		return e.content
	}
	if e.st != nil {
		return e.st.Message()
	}
	return "unknown error"
}

func (e ErrorST) GRPCStatus() *status.Status {
	if e.st == nil {
		return status.New(codes.Internal, "unknown error")
	}
	return e.st
}

func (e ErrorST) AddErrDetails(dat string) ErrorST {
	e.content += " " + dat
	return e
}

func (e ErrorST) Is(err error) bool {
	return e.content == err.Error()
}

func (e ErrorST) IsErr(err error) bool {
	return e == err
}

func (e ErrorST) WithDetails(details ...proto.Message) ErrorST {
	st := e.GRPCStatus()

	v1 := make([]protoadapt.MessageV1, 0, len(details))
	for _, d := range details {
		v1 = append(v1, protoadapt.MessageV1Of(d))
	}

	st2, err := st.WithDetails(v1...)
	if err != nil {
		return ErrorST{st: status.New(codes.Internal, "invalid error details"), content: e.content}
	}
	return ErrorST{st: st2, content: e.content}
}

func Wrap(err error) error {
	if err == nil {
		return nil
	}
	var appErr ErrorST
	if stderrors.As(err, &appErr) {
		return err
	}
	return ServerError.AddErrDetails(err.Error())
}

var (
	RecordNotFound      = ErrorST{st: status.New(codes.NotFound, "record not found"), content: "requested record not found"}
	ParamsNotMatch      = ErrorST{st: status.New(codes.InvalidArgument, "arguments not equals with ")}
	InvalidArguments    = ErrorST{st: status.New(codes.InvalidArgument, "invalid arguments"), content: "some argument missing"}
	RequiredDataMissing = ErrorST{st: status.New(codes.InvalidArgument, "required data missing"), content: "some of transferred data is missing"}
	Conflict            = ErrorST{st: status.New(codes.AlreadyExists, "data collides with exists one"), content: "conflict error"}
	ServerError         = ErrorST{st: status.New(codes.Internal, "server error while progress"), content: "server error appeared"}
	NotConfigured       = ErrorST{st: status.New(codes.Internal, "server error while progress"), content: "service not configured"}
	AccessDenied        = ErrorST{st: status.New(codes.PermissionDenied, "denied"), content: "permissions denied"}
	Unauthenticated     = ErrorST{st: status.New(codes.Unauthenticated, "failed to authorize"), content: "user unauthenticated"}
	AlreadyUsed         = ErrorST{st: status.New(codes.AlreadyExists, "already used"), content: "data is already used"}
	DataExpired         = ErrorST{st: status.New(codes.InvalidArgument, "passed data expired"), content: "accepted data expired"}
	AlreadyExists       = ErrorST{st: status.New(codes.AlreadyExists, "data already exists"), content: "already exists"}
	NotImplemented      = ErrorST{st: status.New(codes.Unimplemented, "not implemented"), content: "not implemented"}
	Unavailable         = ErrorST{st: status.New(codes.Unavailable, "unavailable"), content: "service unavailable"}
	Banned              = ErrorST{st: status.New(codes.PermissionDenied, "user is banned"), content: "user is banned"}
	NeedVerify          = ErrorST{st: status.New(codes.PermissionDenied, "mfa required"), content: "mfa required"}
)
